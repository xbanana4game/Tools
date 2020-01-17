SET LNK_DIR=%~p0
for %%i in (%*) do (
	MKLINK /H "%LNK_DIR%%%~nxi" %%i
)
