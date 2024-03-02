document.addEventListener("DOMContentLoaded", function () {
    // Fetch data for Teacher 1 from the server
    fetch("/teacher1")
      .then(response => response.json())
      .then(data => {
        // Update the DOM with the fetched data
        const studentList = document.getElementById("studentList");
        const teacherDetails = document.getElementById("teacherDetails");
        const teacherNameElement = document.getElementById("teacherName");
        const subjectsTaught = document.getElementById("subjectsTaught");
  
        // Display teacher details
        const teacherInfo = data[0];
        teacherNameElement.innerText = `${teacherInfo.t_name}`;
        subjectsTaught.innerText = `Subjects Taught: ${teacherInfo.sub_name}`;
        teacherDetails.innerText = `Class Coordinator: ${teacherInfo.is_CC ? 'Yes' : 'No'}`;
  
        // Display student details
        data.forEach(student => {
          const listItem = document.createElement("li");
          listItem.innerText = `Roll No: ${student.roll_no}, Name: ${student.s_name}, Marks: ${student.CG_mks}`;
          studentList.appendChild(listItem);
        });
      })
      .catch(error => console.error("Error fetching data:", error));
  });
  