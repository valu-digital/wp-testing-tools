# WP Testing Tools

Testing WordPress plugins is PITA. The wp-browser project makes it possible
but because it requires a working WordPress installation to work. Setting it
up is very laborious. This project aims to automate that part.

It contains following components:

- A Composer installable script for installing WordPress into Docker
  containers, Github Actions or where ever.
- Reuseable Docker enviroment for local testing and debugging with xdebug
- Github Action Workflow
- Plugin boilerplate for fast plugin bootstrapping with proper testing tools
