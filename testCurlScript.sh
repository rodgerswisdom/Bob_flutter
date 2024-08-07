#!/bin/bash

# Define variables
serverUrl="https://bob-server.vercel.app"
email="goathawona@gmail.com"
password="#254Rodgers"

# Function to authenticate and get the auth token
get_auth_token() {
    local serverUrl=$1
    local email=$2
    local password=$3

    response=$(curl -s -X POST "$serverUrl/users/login" \
        -H "Content-Type: application/json" \
        -d "{\"email\":\"$email\", \"password\":\"$password\"}")

    authToken=$(echo "$response" | jq -r '.token')
    if [ "$authToken" == "null" ] || [ -z "$authToken" ]; then
        echo "Error logging in: $(echo "$response" | jq -r '.error')"
        exit 1
    fi

    echo "$authToken"
}

# Function to answer assessment questions
answer_assessment_questions() {
    local serverUrl=$1
    local authToken=$2

    questions=$(cat <<EOF
[
    {"questionId": "0f53be1c-a8e9-4114-a390-30d5b472ef08", "answer": "15000"},
    {"questionId": "10fa9a5b-0d6b-4c49-b570-87f5ae8dc947", "answer": "10000-19999"},
    {"questionId": "26e82f70-4311-4d88-b4c9-6d0e286d8170", "answer": "7000"},
    {"questionId": "3c43cada-2aaf-41c2-9ea5-c2d2a9a607f1", "answer": "Employment"},
    {"questionId": "4d70a426-f204-4f1d-beab-1572df15d8cb", "answer": "50000"},
    {"questionId": "af101a95-77de-42db-af49-df577e4bbbc4", "answer": "Vacation"},
    {"questionId": "f43a7877-21fd-4636-b50f-f2f49527abd6", "answer": "3000"}
]
EOF
)

    response=$(curl -s -X POST "$serverUrl/assessments/answers" \
        -H "Content-Type: application/json" \
        -H "x-token: $authToken" \
        -d "{\"answers\": $questions}")

    echo "Answers submitted successfully:"
    echo "$response" | jq
}

# Main script
authToken=$(get_auth_token "$serverUrl" "$email" "$password")

if [ -n "$authToken" ]; then
    answer_assessment_questions "$serverUrl" "$authToken"
fi

