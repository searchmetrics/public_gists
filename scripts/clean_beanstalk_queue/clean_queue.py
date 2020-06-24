#!/usr/bin/env python

import argparse
import sys
import time
from multiprocessing import Process, Value, Lock
from pystalk import BeanstalkClient, BeanstalkError


class Counter(object):
    def __init__(self, initval=0):
        self._ready = Value('i', initval)
        self._buried = Value('i', initval)
        self.lock = Lock()

    def increment_ready(self):
        with self.lock:
            self._ready.value += 1

    def ready(self):
        with self.lock:
            return self._ready.value

    def increment_buried(self):
        with self.lock:
            self._buried.value += 1

    def buried(self):
        with self.lock:
            return self._buried.value

    def abs(self):
        with self.lock:
            return self._ready.value + self._buried.value


def delete_ready(server, port, tube, jobCounter):
    client = BeanstalkClient(server, port)
    client.watch(tube)
    client.use(tube)

    while True:
        try:
            for job in client.reserve_iter():
                client.delete_job(job.job_id)
                jobCounter.increment_ready()
            processed = jobCounter.abs()
            time.sleep(1)
            if processed == jobCounter.abs():
                break
        except BeanstalkError:
            break
        except KeyboardInterrupt:
            break

def delete_buried(server, port, tube, jobCounter):
    client = BeanstalkClient(server, port)
    client.watch(tube)
    client.use(tube)
    while True:
        try:
            for job in client.peek_buried_iter():
                client.delete_job(job.job_id)
                jobCounter.increment_buried()
            kicked = jobCounter.buried()
            time.sleep(1)
            if kicked == jobCounter.buried():
                break
        except BeanstalkError:
            break
        except KeyboardInterrupt:
            break

def progress(jobCounter):
    while True:
        try:
            processed = jobCounter.abs()
            print("jobs deleted: ", jobCounter.ready(), "ready", jobCounter.buried(), "buried                 ", flush=True, end="\r")
            time.sleep(.1)
            if processed == jobCounter.abs():
                break
        except KeyboardInterrupt:
            break

def print_stats(server, port, tube):
    client = BeanstalkClient(server, port)
    tube_stats=client.stats_tube(tube)
    print("  ready: {:d}\n buried: {:d}\ndelayed: {:d}".format(tube_stats['current-jobs-ready'],
                                                               tube_stats['current-jobs-buried'],
                                                               tube_stats['current-jobs-delayed']))

def main():
    parser = argparse.ArgumentParser(description="Clean a beanstalk tube on a given server")
    parser.add_argument("-n", "--stats_only", dest="stats_only", action='store_true', help="just show tube stats – don't actually delete anything", default=False)
    parser.add_argument("-t", "--tube", dest="tube", help="name of tube to clean", required=True)
    parser.add_argument("-s", "--beanstalk_server", dest="server_address", metavar="SERVER", help="beanstalkd server address", required=True)
    parser.add_argument("-p", "--port", dest="server_port", metavar="PORT", help="beanstalkd server port (default: 11300)", type=int, default=11300)
    parser.add_argument("-r", "--delete_ready", dest="ready_deleter_count", metavar="DR", help="amount of threads to delete ready jobs (default: 10)", type=int, default=10)
    parser.add_argument("-b", "--delete_buried", dest="buried_deleter_count", metavar="DB", help="amount of threads to delete buried jobs (default: 0)", type=int, default=0)


    args = parser.parse_args()
    tube = args.tube
    server = args.server_address
    port = args.server_port
    print("cleaning tube '{:s}' on '{:s}:{:d}'".format(tube, server, port))
    print_stats(server, port, tube)
    if args.stats_only:
        exit(0)
    jobCounter = Counter(0)
    dprocs = [Process(target=delete_ready, args=(server, port, tube, jobCounter,)) for i in range(args.ready_deleter_count)]
    kprocs = [Process(target=delete_buried, args=(server, port, tube, jobCounter,)) for j in range(args.buried_deleter_count)]
    p = Process(target=progress, args=(jobCounter,))
    procs = []
    procs.append(p)
    procs += dprocs
    procs += kprocs

    try:
        for p in procs:
            p.start()
        for p in procs:
            p.join()
    except KeyboardInterrupt:
        pass
    print("jobs deleted: ", jobCounter.ready(), "ready, ", jobCounter.buried(), "buried                 ", flush=True)
    print_stats(server, port, tube)

if __name__ == "__main__":
    main()
