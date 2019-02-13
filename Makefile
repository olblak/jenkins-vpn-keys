.PHONY: encrypt decrypt request sign revokek show-req show-cert


isNameDefined:
ifndef name
$(error name is not set)
endif

encrypt:
	sops -e pki/private/ca.key > pki/private/ca.key.enc

decrypt:
	sops -d pki/private/ca.key.enc > pki/private/ca.key

request: isNameDefined
	./easyrsa gen-req $(name)

sign: isNameDefined
	./easyrsa sign-req client $(name)

revoke: isNameDefined
	./easyrsa revoke $(name)

show-req: isNameDefined
	./easyrsa show-req $(name)

show-cert: isNameDefined
	./easyrsa show-cert $(name)

push-request:
	git add pki/reqs/$(name)
	git commit pki/reqs/$(name) -m 'Submit certificate request for $(name)'
	git push

push-request:
	git add pki/issued/$(name)
	git commit pki/issued/$(name) -m 'Sign certificate request for $(name)'
	git push

# Missing Revoking procedure
