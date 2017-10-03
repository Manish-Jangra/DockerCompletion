function Get-Container {
	Param(
		[ValidateSet('created', 'dead', 'exited', 'paused', 'removing', 'restarting', 'running')]
		[string[]]$Status
	)

	$options = New-Object System.Collections.ArrayList
	if ($Status) {
		foreach ($s in $Status) {
			$options.Add("--filter 'status=$s'") > $null
		}
	} else {
		$options.Add('--all') > $null
	}

	$command = "docker container ls --format '{{{{.Names}}}}' {0}" -f ($options -join ' ')
	Invoke-Expression -Command $command
}

function Get-Image {
	$sorted = docker image ls --format '{{.Repository}}:{{.Tag}}' | Sort-Object
	$sorted | Where-Object { $_ -like '*:latest' } | ForEach-Object { $_ -replace ':latest$' } | Get-Unique
	$sorted | Where-Object { $_ -notlike '*:<none>' }
}

function Get-Network {
	Param(
		[ValidateSet('builtin', 'custom')]
		[string[]]$Type
	)

	$options = New-Object System.Collections.ArrayList
	if ($Type) {
		foreach ($t in $Type) {
			$options.Add("--filter 'type=$t'") > $null
		}
	}

	$command = "docker network ls --format '{{{{.Name}}}}' {0}" -f ($options -join ' ')
	Invoke-Expression -Command $command
}

function Get-Node {
	Param(
		[ValidateSet('manager', 'worker')]
		[string[]]$Role
	)

	$options = New-Object System.Collections.ArrayList
	if ($Role) {
		foreach ($r in $Role) {
			$options.Add("--filter 'role=$r'") > $null
		}
	}

	$command = "docker node ls --format '{{{{.Hostname}}}}' {0}" -f ($options -join ' ')
	Invoke-Expression -Command $command
}

function Get-Secret {
	docker secret ls --format '{{.Name}}'
}
