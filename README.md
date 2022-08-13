# E-commerce--Data-Engineering-Prpject

Architecture diagram

![image](https://user-images.githubusercontent.com/110036451/184507065-6bc62cce-385c-4f2a-a231-d864005e1f94.png)

Running the project

Prerequisites

Docker and Docker Compose v1.27.0
git
Clone the repo using

git clone https://github.com/Rameshei97/online_store.git

cd online_store

Spin up

In your project directory run the following command.

make up

docker ps # to see all the components
Wait for about a minute. You can log into

Dagster UI at http://localhost:3000/
Metabase UI at http://localhost:3001/. Use the following credentials

username: james.holden@rocinante.com
password: password1234

Make sure to switch on the data pipeline in dagster UI, and let it run a few times. In Metabase UI, search for and click on Online store overview using the search bar on the top left corner. This will take you to the dashboard which is fed with the transformed data from the data pipeline.

Tear down
When you are done, you can spin down your containers using the following command.

make down
