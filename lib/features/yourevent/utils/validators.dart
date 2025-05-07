class Validators {
  // Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    // Basic email validation using RegExp
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null; // Valid email
  }

  // Password validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }

    return null; // Valid password
  }

  // Name validation
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }

    if (value.length < 2) {
      return 'Name must be at least 2 characters long';
    }

    return null; // Valid name
  }

  // Event title validation
  static String? validateEventTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Event title is required';
    }

    if (value.length < 3) {
      return 'Event title must be at least 3 characters long';
    }

    return null; // Valid title
  }

  // Date validation (ensure date is not in the past)
  static String? validateFutureDate(DateTime? date) {
    if (date == null) {
      return 'Date is required';
    }

    final now = DateTime.now();
    if (date.isBefore(now)) {
      return 'Date must be in the future';
    }

    return null; // Valid date
  }

  // Hours validation (0-24)
  static String? validateHours(String? value) {
    if (value == null || value.isEmpty) {
      return 'Hours value is required';
    }

    final hours = int.tryParse(value);
    if (hours == null) {
      return 'Please enter a valid number';
    }

    if (hours < 0 || hours > 24) {
      return 'Hours must be between 0 and 24';
    }

    return null; // Valid hours
  }

  // Minutes validation (0-59)
  static String? validateMinutes(String? value) {
    if (value == null || value.isEmpty) {
      return 'Minutes value is required';
    }

    final minutes = int.tryParse(value);
    if (minutes == null) {
      return 'Please enter a valid number';
    }

    if (minutes < 0 || minutes > 59) {
      return 'Minutes must be between 0 and 59';
    }

    return null; // Valid minutes
  }

  // Water intake validation (positive number)
  static String? validateWaterIntake(String? value) {
    if (value == null || value.isEmpty) {
      return 'Water intake value is required';
    }

    final intake = int.tryParse(value);
    if (intake == null) {
      return 'Please enter a valid number';
    }

    if (intake < 0) {
      return 'Water intake cannot be negative';
    }

    return null; // Valid water intake
  }

  // Steps validation (positive number)
  static String? validateSteps(String? value) {
    if (value == null || value.isEmpty) {
      return 'Steps value is required';
    }

    final steps = int.tryParse(value);
    if (steps == null) {
      return 'Please enter a valid number';
    }

    if (steps < 0) {
      return 'Steps cannot be negative';
    }

    return null; // Valid steps
  }
}
