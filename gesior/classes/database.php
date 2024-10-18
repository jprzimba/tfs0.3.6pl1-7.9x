<?php
if(!defined('INITIALIZED'))
	exit;

class Database extends PDO
{
	public $connectionError = '';
	private $connected = false;
	const DB_MYSQL = 1;
	const DB_SQLITE = 2;

	private $db_driver;
	private $db_host = 'localhost';
	private $db_port = '3306';
	private $db_name;
	private $db_username;
	private $db_password;
	private $db_file;

	public $queriesCount = 0;
	public $printQueries = false;

	public function connect()
	{
		return false;
	}

	public function isConnected()
	{
		return $this->connected;
	}

	public function setPrintQueries($value)
	{
		return $this->printQueries = $value;
	}

	public function setConnected($value)
	{
		$this->connected = $value;
	}

	public function getDatabaseDriver()
	{
		return $this->db_driver;
	}

	public function getDatabaseHost()
	{
		return $this->db_host;
	}

	public function getDatabasePort()
	{
		return $this->db_port;
	}

	public function getDatabaseName()
	{
		return $this->db_name;
	}

	public function getDatabaseUsername()
	{
		return $this->db_username;
	}

	public function getDatabasePassword()
	{
		return $this->db_password;
	}

	public function getDatabaseFile()
	{
		return $this->db_file;
	}

	public function setDatabaseDriver($value)
	{
		$this->db_driver = $value;
	}

	public function setDatabaseHost($value)
	{
		$this->db_host = $value;
	}

	public function setDatabasePort($value)
	{
		$this->db_port = $value;
	}

	public function setDatabaseName($value)
	{
		$this->db_name = $value;
	}

	public function setDatabaseUsername($value)
	{
		$this->db_username = $value;
	}

	public function setDatabasePassword($value)
	{
		$this->db_password = $value;
	}

	public function setDatabaseFile($value)
	{
		$this->db_file = $value;
	}

	public function beginTransaction(): bool
	{
		if ($this->isConnected() || $this->connect()) {
			return parent::beginTransaction();
		} else {
			new Error_Critic('', 'Website is not connected to database. Cannot execute "beginTransaction()"');
			return false;
		}
	}	

	public function commit(): bool
	{
		if ($this->isConnected() || $this->connect()) {
			return parent::commit();
		} else {
			new Error_Critic('', 'Website is not connected to database. Cannot execute "commit()"');
			return false;
		}
	}
	
	public function errorCode(): ?string
	{
		if ($this->isConnected() || $this->connect()) {
			return parent::errorCode();
		} else {
			new Error_Critic('', 'Website is not connected to database. Cannot execute "errorCode()"');
			return null;
		}
	}	

	public function errorInfo(): array
	{
		if ($this->isConnected() || $this->connect()) {
			return parent::errorInfo();
		} else {
			new Error_Critic('', 'Website is not connected to database. Cannot execute errorInfo()');
			return [];
		}
	}	

	public function exec(string $statement): int|false
	{
		if ($this->isConnected() || $this->connect()) {
			return parent::exec($statement);
		} else {
			new Error_Critic('', 'Website is not connected to database. Cannot execute exec($statement)');
			return false;
		}
	}
	
	public function getAttribute(int $attribute): mixed
	{
		if ($this->isConnected() || $this->connect()) {
			return parent::getAttribute($attribute);
		} else {
			new Error_Critic('', 'Website is not connected to database. Cannot execute getAttribute($attribute)');
			return null;
		}
	}	

	public static function getAvailableDrivers(): array
	{
		if (self::isConnected() || self::connect()) {
			return parent::getAvailableDrivers();
		} else {
			new Error_Critic('', 'Website is not connected to database. Cannot execute getAvailableDrivers()');
			return [];
		}
	}
	
	public function inTransaction(): bool
	{
		if ($this->isConnected() || $this->connect()) {
			return parent::inTransaction();
		} else {
			new Error_Critic('', 'Website is not connected to database. Cannot execute inTransaction()');
			return false;
		}
	}

	public function lastInsertId($name = null): string
	{
		if ($this->isConnected() || $this->connect()) {
			return parent::lastInsertId($name);
		} else {
			new Error_Critic('', 'Website is not connected to database. Cannot execute lastInsertId()');
			return '';
		}
	}

	public function prepare(string $statement, array $driver_options = []): PDOStatement|false
	{
		if ($this->isConnected() || $this->connect()) {
			return parent::prepare($statement, $driver_options);
		} else {
			new Error_Critic('', 'Website is not connected to database. Cannot execute prepare($statement)');
			return false;
		}
	}	

	public function query(string $statement, ?int $fetchMode = null, mixed ...$fetchModeArgs): PDOStatement|false
	{
		$this->queriesCount++;
		// BETA TESTS - uncomment line below to print all queries on website before execution
		//echo'<br />' . $statement . '<br />';
	
		if($this->isConnected() || $this->connect())
		{
			$ret = parent::query($statement, $fetchMode, ...$fetchModeArgs);
			
			/*
			if($this->printQueries)
			{
				$_errorInfo = $this->errorInfo();
				echo '<table>';
				echo '<tr><td>Query: </td><td>' . $statement . '</td></tr>';
				echo '<tr><td>SQLSTATE: </td><td>' . $_errorInfo[0] . '</td></tr>';
				echo '<tr><td>Driver code: </td><td>' . $_errorInfo[1] . '</td></tr>';
				echo '<tr><td>Error message: </td><td>' . $_errorInfo[2] . '</td></tr>';
				echo '</table>';
			}*/
			return $ret;
		}
		else
			new Error_Critic('', 'Website is not connected to database. Cannot execute query($statement)');
	}
	

	public function quote(?string $string, int $parameter_type = PDO::PARAM_STR): string|false
	{
		if (is_null($string)) {
			return 'NULL'; 
		}
	
		if ($this->isConnected() || $this->connect()) {
			return parent::quote($string, $parameter_type);
		} else {
			new Error_Critic('', 'Website is not connected to database. Cannot execute quote($string, $parameter_type)');
			return false;
		}
	}
	

	public function rollBack(): bool
	{
		if ($this->isConnected() || $this->connect()) {
			return parent::rollBack();
		} else {
			new Error_Critic('', 'Website is not connected to database. Cannot execute rollBack()');
			return false;
		}
	}
	
	public function setAttribute(int $attribute, mixed $value): bool
	{
		if ($this->isConnected() || $this->connect()) {
			return parent::setAttribute($attribute, $value);
		} else {
			new Error_Critic('', 'Website is not connected to database. Cannot execute setAttribute($attribute, $value)');
			return false;
		}
	}	

	public function setConnectionError($string)
	{
		$this->connectionError = $string;
	}
}