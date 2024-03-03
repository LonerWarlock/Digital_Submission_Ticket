document.addEventListener("DOMContentLoaded", function () {
  // Fetch data for Teacher 1 from the server
  fetch("/teacher2")
    .then(response => response.json())
    .then(data => {
      // Update the DOM with the fetched data
      const teacherDetails = document.getElementById("teacherDetails");
      const teacherNameElement = document.getElementById("teacherName");
      const studentTable = document.getElementById("studentTable");

      // Display teacher details
      const teacherInfo = data[0];
      teacherNameElement.innerText = `${teacherInfo.t_name}`;

      // Display additional teacher details
      teacherDetails.innerText = `Subject: ${teacherInfo.sub_name}`;

      // Display student details in a table
      const tableHeader = '<tr><th>Roll No</th><th>Name</th><th>Marks</th><th>Update Marks</th></tr>';
      studentTable.innerHTML = tableHeader;

      data.forEach(student => {
        const row = studentTable.insertRow();
        const cellRollNo = row.insertCell(0);
        const cellName = row.insertCell(1);
        const cellMarks = row.insertCell(2);
        const cellUpdateMarks = row.insertCell(3);

        cellRollNo.innerText = student.roll_no;
        cellName.innerText = student.s_name;
        cellMarks.innerText = student.PA_mks;

        // Create input box for updating marks
        const inputMarks = document.createElement("input");
        inputMarks.type = "number";
        inputMarks.value = student.PA_mks; // Set the default value to the current marks
        cellUpdateMarks.appendChild(inputMarks);

        // Create update button
        const updateButton = document.createElement("button");
        updateButton.innerText = "Update";
        updateButton.addEventListener("click", () => {
          // Call the function to update marks when the button is clicked
          updateMarks(student.roll_no, inputMarks.value);
        });
        cellUpdateMarks.appendChild(updateButton);
      });

      if (teacherInfo.is_CC) {
        // Fetch all students and their attendance
        fetch("/allStudents")
          .then(response => response.json())
          .then(allStudentsData => {

            const classCoordinatorLine = document.getElementById("classCoordinatorLine");
            classCoordinatorLine.innerText = `Class Coordinator`;

            // Display all students and attendance in a table
            const allStudentsTable = document.getElementById("allStudentsTable");
            allStudentsTable.innerHTML = '<tr><th>Roll No</th><th>Name</th><th>Attendance</th><th>Update Attendance</th></tr>';

            allStudentsData.forEach(student => {
              const row = allStudentsTable.insertRow();
              const cellRollNo = row.insertCell(0);
              const cellName = row.insertCell(1);
              const cellAttendance = row.insertCell(2);
              const cellUpdateAttendance = row.insertCell(3);

              cellRollNo.innerText = student.roll_no;
              cellName.innerText = student.s_name;
              cellAttendance.innerText = student.attendance;

              // Allow class coordinators to change attendance
              if (teacherInfo.is_CC) {
                // Create input box for updating attendance
                const inputAttendance = document.createElement("input");
                inputAttendance.type = "number";
                inputAttendance.value = student.attendance; // Set the default value to the current attendance
                cellUpdateAttendance.appendChild(inputAttendance);

                // Create update button for attendance
                const updateAttendanceButton = document.createElement("button");
                updateAttendanceButton.innerText = "Update Attendance";
                updateAttendanceButton.addEventListener("click", () => {
                  // Call the function to update attendance when the button is clicked
                  updateAttendance(student.roll_no, inputAttendance.value);
                });
                cellUpdateAttendance.appendChild(updateAttendanceButton);
              }
            });

            // Show the table for class coordinators
            allStudentsTable.style.display = 'block';
          })
          .catch(error => console.error("Error fetching all students data:", error));
      }
    })
    .catch(error => console.error("Error fetching data:", error));

  // Function to update marks
  function updateMarks(rollNo, newMarks) {
    // Call the API endpoint to update marks
    fetch(`/updateMarks/PA/${newMarks}/${rollNo}`, { method: 'POST' })
      .then(response => response.json())
      .then(data => {
        // Display a success message or handle as needed
        console.log(data.message);
        // You might want to refresh the student data after updating marks
        // Fetch data again or update the specific cell in the table
      })
      .catch(error => console.error("Error updating marks:", error));
  }

  function updateAttendance(rollNo, newAttendance) {
    // Call the API endpoint to update attendance
    fetch(`/updateAttendance/${newAttendance}/${rollNo}`, { method: 'POST' })
      .then(response => response.json())
      .then(data => {
        // Display a success message or handle as needed
        console.log(data.message);
        // You might want to refresh the student data after updating attendance
        // Fetch data again or update the specific cell in the table
      })
      .catch(error => console.error("Error updating attendance:", error));
  } 
});
