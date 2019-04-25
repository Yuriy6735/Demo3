import unittest
from get-prediction.main import get_predictions


class MyFunTest(unittest.TestCase):

    def test_negative(self):
        self.assertEquals(get_predictions("") )


if __name__ == '__main__':
    unittest.main()