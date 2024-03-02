document.addEventListener("DOMContentLoaded", function () {
  fetch("/student1")
    .then(response => response.json())
    .then(data => {
      const studentData = data.length > 0 ? data[0] : {};

    document.getElementById("studentName").innerText = `${studentData.s_name}`;
    document.getElementById("RollNo").innerText = `Roll No: ${studentData.roll_no}`;
    document.getElementById("attendance").innerText = `Attendance: ${studentData.attendance}%`;
    document.getElementById("marksCG").innerText = `Marks in CG: ${studentData.CG_mks}`;
    document.getElementById("marksPA").innerText = `Marks in PA: ${studentData.PA_mks}`;
      
    })
    .catch(error => console.error("Error fetching data:", error));
});
