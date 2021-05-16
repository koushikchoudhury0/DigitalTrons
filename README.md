# Digital Trons NodeJS Assignment

The Problem Statement & Instructions can be found [here](https://docs.google.com/document/d/1dtiwzKZNWYBVXhU5Xa-uuQK7DD5C7EVj1LwOFdZ7ygo/edit)

## Project Structure
- api
    - DigitalTrons.PostMan.json (for Postman)
    - swagger.yaml (for AWS SAM)
- database
    - DigitalTrons.sql (complete Database Export with Data, Schema, Procedures)
- functions (AWS Lambda Function Packageables)
    - AddNode (Add a New File/Folder)
    - DeleteNode (Delete an Existing File/Folder)
    - MoveNode (Change Parent of a File/Folder)
    - Search (To Search a File/Folder By Name)
    - ViewNotifications (To View all Notifications)
- layers
    - layer-1
        - nodejs (Includes Common Libraries and Functions)
- package.json
- package.yaml (AWS SAM Generated)
- README.md (for GitHub)
- template.yaml (for AWS SAM)


## Deployment & Execution
MySQL Version: 8.x <br />
Database Host: AWS RDS (Publicly Accessible) <br />
Architecture: Serverless (AWS Lambda with Layers) <br />
Runtime: Nodejs 12.x <br />
NPM Modules Used: mysql2, aws-sdk <br />
API Host: AWS API Gateway <br />
API Endpoint: https://294mopo2r0.execute-api.ap-south-1.amazonaws.com/development <br />
API Tested Using: Postman <br />
Deployment: AWS SAM (Partially IaaC) <br />
CloudFormation Stack Name: DigitalTrons <br />

**NOTE: All Functions, API Resources, Invoke Permissions were deployed using AWS SAM** <br />
**NOTE: Functions use AWS Secrets Manager to obtain Database Credentials** <br />

## Technical Offloading or Load Distribution
1. The FileSystem Data follows a Hierarchical Model, which is managed as **Adjacent Data** in MySQL, so everytime we needed to find out the exact path at any level, we'd have to run a `Recursive Query` with or without filters. So, `View` named `file_hierarchy` was created that has the `Recursive Query` as it's base. This made querying from the Runtime Environment easy and short.
2. To notify users, we're simply adding an entry each time a new File/Folder is added. This is achieved from a `MySQL Trigger` on the `filesystem` Table that simply puts the name & timestamp of the File/Folder being created into `add_notifcation` Table. The other alternative would have to manually execute a Query inside of a Lambda Function, which would have increased the size of our code.
3. A single `AWS Lambda Layer` called `layer-1` at it's `Version 10` is used that accomodates all libraries and common Functions used by the Lamda Functions.
4. `AWS Secrets Manager` is used to offload the chances of Updating each `Lambda Function` in case a change in credential takes place.

## Tasks & How-to 
**NOTE: All requests must be made in POST Method** <br />
**NOTE: Request Body must be in JSON Format, Responses are also retrieved in JSON Format** <br />
**NOTE: {statusCode: 1[, ...]} indicates a successful execution along with some other optional/expected data** <br />
**NOTE: {statusCode: 0, msg: "ERROR_MSG", [, ...]} indicates a failed execution along with some other optional/expected data** <br />

**Tasks 3,4,7** can be accessed from API Endpoint */search*: <br />
If *Blank Request Body* is provided, *Complete FileSystem* is shown <br />
Sample Request Body: { } <br />
<br />
If *A Node* is provided, *It's Descending Hierarchy* is shown. This also corresponds to the 'Searching' feature. <br />
Sample Request Body: {
    "node": "Folder6"
} <br />
<br />
**Task 1** can be accessed from API Endpoint */add* <br />
Sample Request Body: {
    "path": "/Folder1/Folder4/",
    "d": 1,
    "node": "Folder7"
} <br />
<br />
**Task 2** can be accessed from API Endpoint */delete* <br />
Sample Request Body: {
    "node": "Folder6"
} <br />
<br />
**Task 5** can be accessed from API Endpoint */move* <br />
If *The Target is NOT a FOLDER*, an appropriate error message is returned <br />
Sample Request Body: {
    "node": "File3",
    "target": "Folder1"
} <br />
<br />
**Task 6** can be accessed from API Endpoint */notifications* <br />
Sample Request Body: {} <br />


## Improvments
1. [Security] RDS & Lambda Functions (consequently) should be moved inside of a Private Subnet Group within a VPC
2. [System] Instead of using Node Names as Unique/Primary ID, Numeric or Alphanumeric (such as UUID) should be used to make the System more Resilient and Robust. This would also have implied a 'I-Node' kind of model, which is mostly desirable.
3. [Deployment] To automate the Process of Deployment using CI/CD, AWS CodePipeline along with GitHub or AWS CodeCommit should be used.