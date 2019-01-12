executable = instrswitch

main = src/main.rb
sources = src/*.rb

$(executable): $(sources)
	awk -f generate-executable.awk $(main) > $@ && chmod +x $@

.PHONY: clean
clean:
	$(RM) $(executable)
