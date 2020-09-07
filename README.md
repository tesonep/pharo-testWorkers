Remote Test Workers
===================

This project implements a way of distributing the execution of tests in multiple images running in the same or different machines. This prototype includes the following high-level features:

- Integration with Dr Test to execute the test classes in the cluster.
- Uses RabbitMQ to handle all communications, allowing to scale without problem.
- A watchdog to deploy in the machines running worker instances.
- A client to monitor the available worker instances.
- A way of publishing changes to the images, and also in the future to share the cluster between different users.
- Different strategies to generate the templates (from an existing image, from latest Pharo, from the same image that the client).
- Integration with the Pharo tools and UI.

This prototype uses RabbitMQ to distribute tests to the different worker instances, and also to communicate the watchdogs, the instances and the clients. It uses the STOMP client implementation for Pharo (https://github.com/svenvc/stamp).

This diagram shows a simplify description of the test distribution.

![Basic Test distribution](./docs/basicArchitecture.png "Basic Test distribution")
