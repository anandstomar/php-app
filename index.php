<?php
require_once 'db.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST' && !empty($_POST['name'])) {
    $name = $_POST['name'];
    $stmt = $pdo->prepare('INSERT INTO people (name) VALUES (:name)');
    $stmt->execute(['name' => $name]);
}

$rows = $pdo->query('SELECT id, name FROM people ORDER BY id DESC')->fetchAll(PDO::FETCH_ASSOC);
?>
<!doctype html>
<html>
<head>
  <meta charset="utf-8" />
  <title>Simple PHP Form</title>
</head>
<body>
  <h1>Simple PHP + MySQL</h1>
  <form method="post">
    <input name="name" placeholder="Enter name" required />
    <button type="submit">Save</button>
  </form>

  <h2>Saved names</h2>
  <ul>
  <?php foreach ($rows as $r): ?>
    <li><?=htmlspecialchars($r['name'])?></li>
  <?php endforeach; ?>
  </ul>
</body>
</html>
