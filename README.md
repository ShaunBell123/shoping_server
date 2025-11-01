# 🧩 Project Overview

This project uses Java, Gradle, Spring Boot, Python, FastAPI, Git, Docker, Auth0, Terrifrom, EC2, and GitHub Actions.

My goal at the moment is to add an AWS Gateway and ElastiCache.
This will allow me to make public requests to my network and reduce the amount of compute resources the EC2 instance uses.

## 🧠 Current Setup

When running, you can send a request like this (after authenticating):

Endpoint:
```
http://localhost:8080/scrape
```

Request:
```json
{
  "shops": [
    {
      "shop_name": "asda",
      "products": [
        { "name": "milk" },
        { "name": "bread" }
      ]
    },
    {
      "shop_name": "tesco",
      "products": [
        { "name": "milk" },
        { "name": "bread" },
        { "name": "eggs" },
        { "name": "diet coke" },
        { "name": "chicken" }
      ]
    }
  ]
}
```

Currently, this will go through the first shop page and find products with names closely matching the provided string.

## 🔮 Future Improvements

In the future, I hope to add more filters, such as:

Lowest cost per unit

Size requirements

Brand preferences

## 🔐 Authentication

I also have other endpoints for authentication:

```
http://localhost:8080/
```
Opens a page where the user can click a button to log in.

```
http://localhost:8080/login
```
Opens the Auth0 login page, where the user can log in using Google.

```
http://localhost:8080/dashboard
```
Shows the user their email and username, along with a button that triggers the scrape endpoint (http://localhost:8080/scrape).

## ⚠️ Important

If someone uses this, do not abuse public websites, as you are using someone else’s resources.
Try to use mocked data to simulate the effects of the services instead.

## 🛠️ Technologies

Java / Spring Boot

Gradle

Python / FastAPI

Git / GitHub

Docker

Auth0

AWS EC2

AWS Gateway (planned)

AWS ElastiCache (planned)

GitHub Actions

Terrifrom 
