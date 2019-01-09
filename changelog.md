# Dynamics365Configuration module change log

## Unreleased

* Save-Dynamics365Resource command verifies checksum of the file download
* Install-Dynamics365Prerequisites verifies checksum of the file download
* Install-Dynamics365Prerequisites is not installing the product if it is already installed (idempotency)
* Install-Dynamics365Prerequisites verifies installation via product ID and signals if installation failed (for automatic testing)
* Install-Dynamics365Server is not installing the product if it is already installed (idempotency)
* Install-Dynamics365Server verifies installation via Microsoft.Crm.PowerShell snappin and signals if installation failed (for automatic testing)
* Install-Dynamics365Update is not installing the product if it is already installed (idempotency)
* Install-Dynamics365Update verifies installation via Microsoft.Crm.PowerShell snappin and signals if installation failed (for automatic testing)
* Install-Dynamics365Language is not installing the product if it is already installed (idempotency)
* Install-Dynamics365Update verifies installation via product ID and signals if installation failed (for automatic testing)

## v0.6 Initial public release