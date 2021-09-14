from .context import sample
from sample import sample_sum_func


def test_sample_sum_func():
    """testing sum_func"""
    result = sample_sum_func(1, 2)
    assert result == 3
