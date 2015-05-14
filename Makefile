xml2rfc ?= xml2rfc -v

#draft := draft-procter-dispatch-outbound-discovery
draft := draft-procter-dispatch-outbound-unaptr

current_ver := $(shell ls ${draft}-*.xml | xargs -I foo basename foo .xml | tail -1 | sed -e"s/.*-//")
ifeq "${current_ver}" ""
next_ver ?= 00
else
next_ver ?= $(shell printf "%.2d" $$((1$(current_ver)-99)))
endif
next := $(draft)-$(next_ver)

.PHONY: latest submit clean

latest: $(draft).txt $(draft).html

submit: $(next).txt

clean:
	-rm -f $(draft).txt $(draft).html
	-rm -f $(next).txt $(next).html
	#-rm -f $(draft)-[0-9][0-9].xml

$(next).xml: $(draft).xml
	sed -e"s/$(basename $<)-latest/$(basename $@)/" \
	    -e"s/DAY/$(shell date +%d)/" \
	    -e"s/MONTH/$(shell date +%B)/" \
	    -e"s/YEAR/$(shell date +%Y)/" \
		$< > $@

%.txt: %.xml
	$(xml2rfc) $< $@

%.html: %.xml
	$(xml2rfc) --html $< $@
