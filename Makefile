# Makefile IDS Project
# Marek Gergel (xgerge01)

XLOGIN01:=xkundr07
XLOGIN02:=xgerge01
PROJ_NAME:=$(XLOGIN01)_$(XLOGIN02)

.PHONY: zip tar

zip:
	zip -r $(PROJ_NAME).zip *.sql *.pdf

tar:
	tar -czf $(PROJ_NAME).tar.gz *.sql *.pdf