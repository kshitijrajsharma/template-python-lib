import pytest

from mylib import greet


def test_greet_returns_greeting() -> None:
    assert greet("world") == "Hello, world!"


@pytest.mark.parametrize(
    ("name", "expected"),
    [
        ("Kshitij", "Hello, Kshitij!"),
        ("", "Hello, !"),
        ("सगरमाथा", "Hello, सगरमाथा!"),
    ],
)
def test_greet_parametrized(name: str, expected: str) -> None:
    assert greet(name) == expected
