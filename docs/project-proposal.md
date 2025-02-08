# Project Proposal

> Project Proposal: 🌸Reverse Proxy Firewall & Network Suite 🌸

## 0. Table of Contents

1. [Introduction](#1-introduction)
2. [Project Objectives](#2-project-objectives)
3. [Project Phases](#3-project-phases)

   3.1. [Phase 0: Foundational Components](#31-phase-0-foundational-components)

   3.2. [Phase 1: WAF Reverse Proxy](#32-phase-1-waf-reverse-proxy)

   3.3. [Phase 2: Security Mechanisms](#33-phase-2-security-mechanisms)

   3.4. [Phase 3: Testing and Monitoring](#34-phase-3-testing-and-monitoring)

   3.5. [Phase 4: Advanced Network Tooling](#35-phase-4-advanced-network-tooling)

   3.6. [Phase 5: Optional Features](#36-phase-5-optional-features)

4. [Project Relevance and Learning Outcomes](#4-project-relevance-and-learning-outcomes)
5. [Future Goal (Core WAF Engine)](#5-future-goal-core-waf-engine)

## 1. Introduction

This project aims to develop a hybrid `Network Intrusion Detection System` (NIDS) and `Intrusion Prevention System` (IPS) as part of an integrated network security suite. The system will implement a `Web Application Firewall` (WAF) in Go (Golang), utilizing its performance and concurrency features to create a fast, highly efficient security solution.

## 2. Project Objectives

Given the complexity and technical learning curve, the project is divided into five phases, each targeting specific components and functionalities of the network security suite. The core project spans Phases 1 through 3, while Phase 4 involves dependency tooling that will be addressed as needed. The final phase, Phase 5, is optional and will be undertaken if time permits.

## 3. Project Phases

> Breakdown of the Project with Estimated Timeline for all Moving Components

### 3.1 Phase 0: Foundational Components

>Target Objectives: Set up development environment

- Use `Docker Compose` to set up a local isolated network
- Hook 4 Docker containers: `server`, `client`, `attacker` & `waf-deploy`
- `server`: Run a Go server with random data stream
- `client`: Basic client to receive data
- `attacker`: Simulate attacks like DDoS, packet flooding
- `waf-deploy`: Docker container for main project

jk### 3.2 Phase 1: WAF Reverse Proxy

>Target Objectives: Implement the core reverse proxy functionality and request parsing. (2-3 months)

#### 3.2.1 HTTP Proxy (Reverse Proxy)

- Implement using Go's `net/http` package
- Intercept incoming HTTP/HTTPS requests
- Forward legitimate requests to the backend server
- Handle TLS/SSL using `crypto/tls` package
- Use `gorilla/mux` for routing, `martini` for middleware

#### 3.2.2 Request Parser

- Parse HTTP headers, body, and URL parameters
- Handle different content types (e.g., JSON, XML, form-data)
- Decode encoded content (e.g., base64, URL encoding)
- Work with Go libraries: `json`, `xml`, `url`, `mime/multipart`

#### 3.2.3 Logging and Alerting System

- Log all requests and their outcomes
- Implement real-time threat alerting
- Use `logrus` for structured logging, `gopkg.in/gomail.v2` for email alerts

### 3.3 Phase 2: Security Mechanisms

>Target Objectives: Implement the core security features, including rate limiting and IP reputation management. (2-3 months)

#### 3.3.1 Rate Limiter

- Track request rates per IP, user, or endpoint
- Understand `token bucket` or `sliding window` algorithms
- Set configurable rate limits and time windows
- Learn to use `juju/ratelimit`, `golang.org/x/time/rate`

#### 3.3.2 IP Reputation Manager

- Maintain a local database of IP reputations
- Implement IP blocking and unblocking mechanisms
- Implement Whitelist/Blacklist pools
- Learn `boltdb` for lightweight database, `bloom` for IP reputation filtering

#### 3.3.3 Rule Engine

- Define a rule structure (e.g., conditions, actions)
- Implement rule matching logic
- Support various rule types (regex, exact match, range)
- Implement signature-based threat detection (e.g., Nimda worm)
- Use regular expressions with `regexp`, `antchfx/xmlquery` for XML rule processing

### 3.4 Phase 3: Testing and Monitoring

>Target Objectives: Implement the testing suite and monitoring/dashboard components. (2-3 months)

#### 3.4.1 Testing Suite

- Implement traffic simulation for controlled testing
- Create various attack scenario simulations
- Develop stress testing tools (e.g., packet flooding)
- Consider manual implementation or use `fortio` for load testing, `gobench` for benchmarking

#### 3.4.2 Logging and Alerting System

- Log all requests and their outcomes
- Implement real-time event-based alerting
- Track key metrics (requests per second, block rate, etc.)
- Define alert conditions (e.g., high block rate, unusual traffic patterns)
- Support alert channels like email

### 3.5 Phase 4: Advanced Network Tooling

>Target Objectives: Implement the packet analyzer, certificate manager, and network scanner. (3-4 months)

#### 3.5.1 Certificate Manager

- Generate and manage SSL/TLS certificates
- Learn `acme/autocert` for automatic certificate management, `certmagic`

#### 3.5.2 Packet Analyzer (as per need)

- Perform deep packet inspection
- Look into `gopacket` for packet processing, `pcap` for packet capture

#### 3.5.3 Network Scanner (as per need)

- Implement ping sweeper for network discovery
- Develop port scanning (SYN scan)
- Implement service fingerprinting
- Implement basic OS detection
- Enable CSV export of scan results
- Consider common implementations like `masscan`, `zmap`

### 3.6 Phase 5: Optional Features

>Target Objectives: Implement the optional web dashboard feature. (1-2 months)

#### 3.6.1 Web Dashboard (Optional)

- Create visual representation of network metrics
- Implement log viewer with live timestamp
- Develop rule management interface
- Display key security metrics
- Implement real-time updates of network status
- Consider scratch implementation or use `goadmin` for dashboard creation, `gorilla/websocket` for real-time updates
- Implement performance metrics and charts

## 4. Project Relevance and Learning Outcomes

- Address real-world cybersecurity challenges, particularly in network threat detection and mitigation
- Design and implement a comprehensive network security suite
- Gain practical experience in developing network security tools and WAF
- Develop a hybrid NIDS/IPS system for real-time threat detection and prevention
- Enhance programming skills in Go, a modern and efficient language
- Utilize Go programming language to ensure high performance and concurrency
- Create a modular and extensible architecture for future enhancements
- Deepen understanding of network protocols and security concepts

## 5. Future Goal (Core WAF Engine)

> Target Objectives: Learn and develop detection engines

- SQL Injection detection engine
- Cross-Site Scripting (XSS) detection engine
- Cross-Site Request Forgery (CSRF) detection engine
- Remote Code Execution detection engine
- Path Traversal detection engine
- Command Injection detection engine
- XML External Entity (XXE) Injection detection engine
