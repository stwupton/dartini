part of collision_detector;

bool inRange(num n, num min, num max) =>
  n > math.min(min, max) && n < math.max(min, max);
