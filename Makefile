executable = instrswitch
install-dest = $(HOME)/bin

main = src/main.rb

$(executable): $(main)
	awk -f generate-executable.awk $(main) > $@ && chmod +x $@

.PHONY: install
install: $(executable)
	cp $< $(install-dest)/$<

.PHONY: clean
clean:
	$(RM) $(executable)
