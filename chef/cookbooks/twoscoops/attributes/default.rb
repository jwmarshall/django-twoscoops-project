# Default attributes

default["twoscoops"]["project_name"] = nil

default["twoscoops"]["database"]["engine"] = "django.db.backends.postgresql_psycopg2"
default["twoscoops"]["database"]["username"] = "postgres"
default["twoscoops"]["database"]["password"] = "vagrant"
default["twoscoops"]["database"]["host"] = "localhost"
default["twoscoops"]["database"]["port"] = ""

default["twoscoops"]["superuser"]["username"] = "vagrant"
default["twoscoops"]["superuser"]["password_hash"] = "pbkdf2_sha256$10000$NoIByEhX0v78$UgkCwmSHBNYiFPD0zCkZ9x+S7z5tlRysHv/L68OJdxc="

