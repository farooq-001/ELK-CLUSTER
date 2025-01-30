#!/bin/bash

# Elasticsearch Configuration
ES_HOST="localhost"
ES_PORT="9200"
ES_USER="root"   # User
ES_PASS="babafarooq001@"   # Password

# Function to display the menu
show_menu() {
    echo "--------------------------------------------"
    echo " Elasticsearch Management Script "
    echo "--------------------------------------------"
    echo "1) Check Cluster Health"
    echo "2) Get Cluster State"
    echo "3) Get Cluster Settings"
    echo "4) List All Indices"
    echo "5) Create an Index"
    echo "6) Delete an Index"
    echo "7) Search All Documents"
    echo "8) Get Document by ID"
    echo "9) Insert a Document"
    echo "10) Update a Document"
    echo "11) Delete a Document"
    echo "12) Exit"
    echo "--------------------------------------------"
}

# Function to execute commands with authentication
execute_command() {
    case $1 in
        1) curl -u "$ES_USER:$ES_PASS" -X GET "$ES_HOST:$ES_PORT/_cluster/health?pretty" ;;
        2) curl -u "$ES_USER:$ES_PASS" -X GET "$ES_HOST:$ES_PORT/_cluster/state?pretty" ;;
        3) curl -u "$ES_USER:$ES_PASS" -X GET "$ES_HOST:$ES_PORT/_cluster/settings?pretty" ;;
        4) curl -u "$ES_USER:$ES_PASS" -X GET "$ES_HOST:$ES_PORT/_cat/indices?v" ;;
        5) 
            echo "Enter Index Name: "
            read index_name
            curl -u "$ES_USER:$ES_PASS" -X PUT "$ES_HOST:$ES_PORT/$index_name?pretty"
            ;;
        6) 
            echo "Enter Index Name to Delete: "
            read index_name
            curl -u "$ES_USER:$ES_PASS" -X DELETE "$ES_HOST:$ES_PORT/$index_name?pretty"
            ;;
        7) 
            echo "Enter Index Name: "
            read index_name
            curl -u "$ES_USER:$ES_PASS" -X GET "$ES_HOST:$ES_PORT/$index_name/_search?pretty"
            ;;
        8) 
            echo "Enter Index Name: "
            read index_name
            echo "Enter Document ID: "
            read doc_id
            curl -u "$ES_USER:$ES_PASS" -X GET "$ES_HOST:$ES_PORT/$index_name/_doc/$doc_id?pretty"
            ;;
        9) 
            echo "Enter Index Name: "
            read index_name
            echo "Enter Document ID: "
            read doc_id
            echo "Enter JSON Data (e.g., {\"name\": \"John\"}):"
            read doc_data
            curl -u "$ES_USER:$ES_PASS" -X POST "$ES_HOST:$ES_PORT/$index_name/_doc/$doc_id?pretty" -H "Content-Type: application/json" -d "$doc_data"
            ;;
        10) 
            echo "Enter Index Name: "
            read index_name
            echo "Enter Document ID: "
            read doc_id
            echo "Enter JSON Update Data (e.g., {\"doc\": {\"age\": 30}}):"
            read update_data
            curl -u "$ES_USER:$ES_PASS" -X POST "$ES_HOST:$ES_PORT/$index_name/_update/$doc_id?pretty" -H "Content-Type: application/json" -d "$update_data"
            ;;
        11) 
            echo "Enter Index Name: "
            read index_name
            echo "Enter Document ID to Delete: "
            read doc_id
            curl -u "$ES_USER:$ES_PASS" -X DELETE "$ES_HOST:$ES_PORT/$index_name/_doc/$doc_id?pretty"
            ;;
        12) exit 0 ;;
        *) echo "Invalid option. Please try again." ;;
    esac
}

# Main loop
while true; do
    show_menu
    echo -n "Choose an option (1-12): "
    read choice
    execute_command $choice
    echo ""
    echo "Press Enter to continue..."
    read
done
