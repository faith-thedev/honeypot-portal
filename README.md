# Web Application Honeypot & Telemetry System

A Flask and MySQL security service designed to simulate a student authentication portal, intercept unauthorized access attempts, and log telemetry data for threat analysis.

## Features
- Decoy authentication endpoints to capture unauthorized access and brute-force attempts
- Automated data-capture pipeline logging IP addresses, request headers, timestamps, and payload metadata
- Relational schema in MySQL designed to store and query threat intelligence telemetry
- Backend request middleware to classify and monitor suspicious traffic patterns

## Stack
- Python
- MySQL
- Postman
- Git

