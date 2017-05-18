import unittest

import threading
from six.moves import range


class MyTestCase(unittest.TestCase):

    def test_threading(self):
        """Make a bunch of threads"""
        for i in range(20):
            threads = [threading.Thread(target=noop, args=()) for _ in range(100)]
            for t in threads:
                t.start()
            for t in threads:
                t.join(30)


def noop():
    return
