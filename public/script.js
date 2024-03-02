function redirectToDashboard(userType) {
    // Redirect logic based on userType
    switch (userType) {
      case 'student1':
        window.location.href = 'student1_dashboard.html';
        break;
      case 'student2':
        window.location.href = 'student2_dashboard.html';
        break;
      case 'teacher1':
        window.location.href = 'teacher1_dashboard.html';
        break;
      case 'teacher2':
        window.location.href = 'teacher2_dashboard.html';
        break;
      default:
        console.error('Invalid userType');
    }
  }
  