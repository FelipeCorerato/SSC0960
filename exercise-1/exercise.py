def is_prime(n, i = 2):
    if n <= 1 or n % i == 0:
        return False

    if n <= 3 or i * i > n:
        return True

    return is_prime(n, i + 1)

def find_next_prime(current, end):
    if current > end:
        return None

    if is_prime(current):
        return current

    return find_next_prime(current + 1, end)

def prime_interval(x, y, last_prime = None):
    if x > y:
        return 0

    next_prime = find_next_prime(x, y)
    if next_prime is None:
        return 0

    interval = 0
    if last_prime is not None:
        interval = next_prime - last_prime

    return max(interval, prime_interval(next_prime + 1, y, next_prime))

def largest_prime_interval(x, y):
    return prime_interval(x, y)

x = int(input())
y = int(input())

print(largest_prime_interval(x, y))
