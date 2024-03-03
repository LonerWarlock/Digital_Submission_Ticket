document.addEventListener("DOMContentLoaded", function () {
  // Fetch data for Teacher 1 from the server
  fetch("/teacher1")
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
        cellMarks.innerText = student.CG_mks;

        // Create input box for updating marks
        const inputMarks = document.createElement("input");
        inputMarks.type = "number";
        inputMarks.value = student.CG_mks; // Set the default value to the current marks
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
      
      // Display Class Coordinator line after the table
      const classCoordinatorLine = document.createElement("p");
      classCoordinatorLine.innerText = `Class Coordinator: ${teacherInfo.is_CC ? 'Yes' : 'No'}`;
      document.body.appendChild(classCoordinatorLine);
    })
    .catch(error => console.error("Error fetching data:", error));

  // Function to update marks
  function updateMarks(rollNo, newMarks) {
    // Call the API endpoint to update marks
    fetch(`/updateMarks/CG/${newMarks}/${rollNo}`, { method: 'POST' })
      .then(response => response.json())
      .then(data => {
        // Display a success message or handle as needed
        console.log(data.message);
        // You might want to refresh the student data after updating marks
        // Fetch data again or update the specific cell in the table
      })
      .catch(error => console.error("Error updating marks:", error));
  }

});
