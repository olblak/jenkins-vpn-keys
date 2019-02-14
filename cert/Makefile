.PHONY: clean commit-request commit-signed encrypt decrypt isNameDefined request revoke show-req show-cert signed

clean: 
	rm pki/private/ca.key

commit-request:
	git add pki/reqs/$(name)
	git commit pki/reqs/$(name) -m 'Submit certificate request for $(name)'

commit-signed:
	git add pki/issued/$(name)
	git commit pki/issued/$(name) -m 'Sign certificate request for $(name)'

encrypt:
	sops -e pki/private/ca.key > pki/private/ca.key.enc
	sops -e pki/private/ca.pass > pki/private/ca.pass.enc

decrypt:
	sops -d pki/private/ca.key.enc > pki/private/ca.key
	sops -e pki/private/ca.pass.enc > pki/private/ca.pass

isNameDefined:
	@NAME=$(name); if [ "$$NAME" == "" ]; then echo "Missing argument name=<username>"; exit 1 ; fi

request: isNameDefined
	../easyrsa gen-req $(name)

revoke: isNameDefined
	../easyrsa revoke $(name)

show-req: isNameDefined
	../easyrsa show-req $(name)

show-cert: isNameDefined
	../easyrsa show-cert $(name)

signed: isNameDefined
	../easyrsa sign-req client $(name)

# Missing Revoking procedure
