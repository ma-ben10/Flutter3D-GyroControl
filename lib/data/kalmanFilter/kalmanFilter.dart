class KalmanFilter {
  double _q;

  /// Process noise covariance
  double _r;

  /// Measurement noise covariance
  double _x;

  /// Value (initial estimate)
  double _p;

  /// Estimation error covariance
  double _k = 0;

  /// Kalman gain

  KalmanFilter(this._q, this._r, this._x, this._p);

  double filter(double measurement) {
    /// Update the Kalman gain
    _k = _p / (_p + _r);

    /// Update the estimate
    _x = _x + _k * (measurement - _x);

    /// Update the error covariance
    _p = (1 - _k) * _p + _q;

    return _x;
  }
}
