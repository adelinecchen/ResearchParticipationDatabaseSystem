<?php
include "db_connect.php";

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $first_name = $_POST['first_name'];
    $last_name  = $_POST['last_name'];
    $email      = $_POST['email'];
    $password   = password_hash($_POST['password'], PASSWORD_DEFAULT);
    $role       = $_POST['role'];

    $sql = "INSERT INTO users (first_name, last_name, email, password, role)
            VALUES ('$first_name', '$last_name', '$email', '$password', '$role')";

    if ($conn->query($sql) === TRUE) {
        echo "Account created successfully!";
    } else {
        echo "Error: " . $conn->error;
    }
}
?>

<form action="register.php" method="post">
  First Name: <input type="text" name="first_name"><br>
  Last Name: <input type="text" name="last_name"><br>
  Email: <input type="email" name="email"><br>
  Password: <input type="password" name="password"><br>
  Role:
  <select name="role">
    <option value="student">Student</option>
    <option value="researcher">Researcher</option>
  </select><br>
  <input type="submit" value="Register">
</form>