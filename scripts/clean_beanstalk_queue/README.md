# Cleaning a beanstalk queue
There is no command to empty/flush a queue on a beanstalkd server, despite being [requested for over a decade](https://github.com/beanstalkd/beanstalkd/issues/25) now.

So whenever there is need to clean a tube on beanstalkd server, all jobs need to be deleted individually. In order to completely empty a queue,
all *ready* jobs need to be **reserved** and then **deleted**. If there are *buried* jobs on the queue, they can get **deleted** directly. 

                            +-------------+                     
     JOB.put (with delay)-->|   delayed   |<-----+              
                            +------+------+      |              
                                   |             +-------------+
                                   |             |  reserved   |
                                   v             +------+---+--+
                            +-------------+      |   ^  |   |   
     JOB.put -------------->|    ready    |<-----+   |  |   |   
                            +-------------+----------+  |   |   
                                                        |   |   
                            +-------------+<------------+   v   
                            |   deleted   |<-----+-------------+
                            +-------------+      |    buried   |
                                                 +-------------+

## Parameters
The script takes a bunch of parameters: 

    usage: clean_queue.py [-h] [-n] -t TUBE -s SERVER [-p PORT] [-r DR] [-b DB]
    
    Clean a beanstalk tube on a given server
    
    optional arguments:
      -h, --help            show this help message and exit
      -n, --stats_only      just show tube stats – don't actually delete anything
      -t TUBE, --tube TUBE  name of tube to clean
      -s SERVER, --beanstalk_server SERVER
                            beanstalkd server address
      -p PORT, --port PORT  beanstalkd server port (default: 11300)
      -r DR, --delete_ready DR
                            amount of threads to delete ready jobs (default: 10)
      -b DB, --delete_buried DB
                            amount of threads to delete buried jobs (default: 0)

## Just checking
Passing the `-n` flag to the script will just print the selected tube's statistics

    $ ./clean_queue.py -s localhost -t default -n
    cleaning tube 'default' on 'localhost:11300'
      ready: 0
     buried: 0
    delayed: 0

and then exit.

## Deleting ready and buried jobs
By default the script does not clean *buried* jobs, but only *ready* ones. In order to do that the script iterates over
all ready jobs, reserves and then deletes them.
By changing the amount of threads to delete *ready* and *buried* jobs it is possible to either only **delete** *buried* jobs
(e.g. `./clean_queue.py -r 0 -b 10 …`) or do both in parallel (e.g. `./clean_queue.py -r 10 -b 10`).

If there are *delayed* jobs, they need to be *ready* before they can get deleted. 
