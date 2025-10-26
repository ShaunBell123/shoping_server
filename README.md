java, gradle, sprint boot, python, fastapi, git, docker, auth0, ec2, github actions.

Right now, I am trying to add Docker to my EC2 instance by including it in the user_data section of terraform/test_project/compute.tf. I am running into a race condition because the private EC2 instance does not have internet access to install Docker Compose.

My goal at the moment is to get the EC2 instance working properly. After that, I plan to add an AWS Gateway and ElastiCache. This will allow me to make public requests to my network and reduce the amount of compute resources the EC2 instance uses.

At the moment, when running locally, you can send a request like this:
endpoint:
http://localhost:8080/scrape
request:
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
        { "name": "diet coke"},
        { "name": "chicken"}
      ]
    }
  ]
}

Currently, this will go through the firs shop page and find products with names closely matching the provided string. In the future, I hope to add more filters, such as:

Lowest cost per unit
Size requirements
Brand preferences

I also have other endpoints for authentication:

http://localhost:8080/
Opens a page where the user can click a button to log in.

http://localhost:8080/login
Opens the Auth0 login page, where the user can log in using Google.

http://localhost:8080/dashboard
Shows the user their email and username, along with a button that triggers the scrape endpoint (http://localhost:8080/scrape).

Important: If someone uses this, do not abuse public websites, as you are using someone else’s resources. Try to use mocked data to simulate the effects of the services instead.