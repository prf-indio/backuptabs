extension_name := backuptabs
extension_uuid := {79b7b437-6848-4409-a8fa-cc08178da660}
profile_dir := Desenvolvimento
ZIP := zip
xpi_file := $(extension_name).xpi
os_type := $(patsubst darwin%,darwin,$(shell echo $(OSTYPE)))
ifeq ($(os_type), darwin)
  profile_location := \
    ~/Library/Application\ Support/Firefox/Profiles/$(profile_dir)/extensions/\{$(extension_uuid)\}
else
  ifeq ($(os_type), linux-gnu)
    profile_location := \
      ~/.mozilla/firefox/$(profile_dir)/extensions/\{$(extension_uuid)\}
  else
    profile_location := \
      "$(subst \,\\,$(APPDATA))\\Mozilla\\Firefox\\Profiles\\$(profile_dir)\\extensions\\{$(extension_uuid)}"
  endif
endif

build_dir := build

.PHONY: all
all: $(xpi_file)
	@echo
	@echo "Concluido!"
	@echo

.PHONY: clean
clean:
	@rm -rf $(build_dir)
	@rm -f $(xpi_file)
	@echo "Limpeza feita."

xpi_built := install.rdf \
             chrome.manifest \
             $(wildcard content/*.js) \
             $(wildcard content/*.xul) \
             $(wildcard content/*.xml) \
             $(wildcard content/*.css) \
             $(wildcard skin/*.css) \
             $(wildcard skin/*.png) \
             $(wildcard locale/*/*.dtd) \
             $(wildcard locale/*/*.properties)

# This builds everything except for the actual XPI, and then it copies it to the
# specified profile directory, allowing a quick update that requires no install.
.PHONY: install
install: $(build_dir) $(xpi_built)
	@echo "Installing in profile folder: $(profile_location)"
	@cp -Rf $(build_dir)/* $(profile_location)
	@echo "Instalando na pasta do perfil. Feito!"
	@echo


$(xpi_file): $(xpi_built)
	@echo "Creating XPI file."
	@$(ZIP) $(xpi_file) $(xpi_built)
	@echo "Limpando arquivo XPI. Feito!"
