# variables
$project_name = "app"
$ruff_settings = @"

[tool.ruff]
exclude = [
    ".venv",
    "venv",
    "__pycache__",
    ".git",
]
line-length = 120
indent-width = 4
target-version = "py312"

[tool.ruff.lint]
select = ["E4", "E7", "E9", "F", "B", "Q"]
fixable = ["ALL"]
unfixable = []

[tool.ruff.format]
quote-style = "double"
indent-style = "space"
skip-magic-trailing-comma = false
line-ending = "auto"
"@

function Write-Process($msg) {
    Write-Host $msg -ForegroundColor Green
}

function Write-Error($msg) {
    Write-Host $msg -ForegroundColor Red
}

# install poetry
Write-Process "1. install poetry" 
try {
    poetry --version
    Write-Output "poetry had been installed"
}
catch {
    (Invoke-WebRequest -Uri https://install.python-poetry.org -UseBasicParsing).Content | python3 -
    Set-Item Env:Path $Env:Path";%APPDATA%\Python\Scripts"
    Write-Output "poetry was installed"
}
finally {
}

# set poetry config
Write-Process "2. set poetry config"
try {
    poetry config virtualenvs.in-project true
}
catch {
}
finally {
    Write-Output "poetry config virtualenvs.in-project is true"
}

# create new project
Write-Process "3. create new project"
try {
    If (!(Test-Path ./$project_name)) {
        poetry new $project_name
        Write-Output "poetry new $project_name was created"
    }
    else {
        Write-Error "project $project_name is already exist"
        exit
    }
}
catch {
}
finally {
}

# add library and ruff settings
Write-Process "4. add library and ruff settings"
try {
    cd $project_name
    poetry add fastapi uvicorn[standard]
    poetry add --group dev pytest httpx
    Write-Output "added fastapi uvicorn pytest httpx"
    Add-Content ./pyproject.toml $ruff_settings
    Write-Output "added ruff settings"
}
catch {
}
finally {   
}

