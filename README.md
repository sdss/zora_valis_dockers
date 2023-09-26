# zora_valis_dockers
docker setup for zora and valis

This is a docker setup for running Zora and Valis together.

## Setup

1. Clone this repo: `git clone https://github.com/sdss/zora_valis_dockers.git`
2. cd `zora_valis_dockers`
3. Clone the repos with the script: `./get_repos.sh`

The script clones the repos into the following directories:
- ./valis/valis
- ./zora/zora

## Development

This sets up the framework for a development environment.  The development docker files are marked with a `dev` suffix.  To build and run the development docker system, run the following command:

 `docker-compose -f docker-compose-dev.yml up --build`

This exposes Valis and Zora, on localhost ports 8000 and 3000 respectively. Navigate to
- Valis: http://localhost:8000
- Zora: http://localhost:3000

**Valis** is the backend python API, based on FastAPI
**Zora** is the frontend UI, based on Vue and Vuetify

If everything loaded correctly, you should see the following:
- In Valis, a small JSON blob containing `{Hello SDSS: "This is the FastAPI World"}`
- In Zora, a dark-mode UI with a header bar containing text "SDSS", a "Data Release" dropdown menu displaying a public DR, e.g. DR18, and a login icon.


To shut the docker container down, hit `Ctrl-C` and run:

`docker-compose -f docker-compose-dev.yml down`


### Database Connection

Valis uses the `sdssdb` package for all connections to databases.  The most relevant database for the API is the `sdss5db` on `pipelines.sdss.org`.  The easiest way to connect is through a local SSH tunnel. To set up a tunnel,

1. Add the following to your `~/.ssh/config`. Replace `unid` with your Utah unid.

```
Host pipe
        HostName pipelines.sdss.org
        User [unid]
        ForwardX11Trusted yes
        ProxyCommand ssh -A [unid]@mwm.sdss.org nc %h %p
```
1. In a terminal, create an ssh tunnel to the pipelines database localhost port 5432, to a some local port. E.g. this maps the remote db localhost port 5432 to local machine on port 6000.
```
    ssh -L 6000:localhost:5432 pipe
```
2. Optionally, update your `~/.pgass` file with the following lines. Replace `port`, `unid`, and `password`, with your tunneled port, Utah unid, and db password, respectively. Alternatively, just set the VALIS_DB_PASS environment variable with your database password.
```
localhost:[port]:*:[unid]:[password]
host.docker.internal:[port]:*:[unid]:[password]
```
3. Set the following environment variables.

- export VALIS_DB_PORT=6000
- export VALIS_DB_USER={unid}
- export VALIS_DB_PASS={password} (if skipped step 2.)

4. Run the docker-compose up command.  The dockerized API will now be able to connect to your local tunneled database connection.


### SDSS SAS

The SDSS SAS directory is automatically volume mounted into the container, using the environment variable `$SAS_BASE_DIR`.  Set this envar to your local top-level SAS directory.

### Updating the Repos
To pull down the latest changes in valis and zora, either `git pull` within each repo directory or run `./get_repos.sh -u` at the top level.

## Production

This sets up the framework for a production environment.  Build and run the production docker system with the following command:

 `docker-compose -f docker-compose.yml up --build`

This exposes Valis on localhost port 8000, and Zora on nginx localhost port 8080. Navigate to
- Valis: http://localhost:8000
- Zora: http://localhost:8080

The main differences in this build are the following:

1. Zora and Valis are served by an nginx service
2. Zora static files are built for production, in `../dist`
3. Valis is mounted to a unix socket

## Resources

- Zora
- Valis
- FastAPI
- Vue
- Vuetify

# Develop Outside Docker

To develop outside of the docker setup, it's very similar setup.

## Zora

In on terminal, clone the zora repo and run
```
cd zora
npm install
npm run dev
```
Go to localhost:3000

## Valis
In another terminal, clone the valis repo and run
```
cd valis
poetry shell  # create a new virtual env
poetry install  # install the project
exit  # exit the venv

# command to run in your isolated venv
poetry run uvicorn valis.wsgi:app --port 8000 --reload
```
Go to localhost:8000

## Database
In a third terminal, create an SSH tunnel to the remote `sdss5db` db following the steps above.

An alternative to the above step 3 is to use the valis configuration file. Create or modify the `~/.config/sdss/valis.yaml` with the following config variables
```
allow_origin: ['http://localhost:3000']
db_remote: true
db_port: [port]
db_user: [unid]
```