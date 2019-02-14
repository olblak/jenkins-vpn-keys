.PHONY: clean encrypt decrypt isNameDefined request revoke show-req show-cert sign

clean: 
	rm pki/private/ca.key

encrypt:
	sops -e pki/private/ca.key > pki/private/ca.key.enc
	sops -e pki/private/ca.pass > pki/private/ca.pass.enc

decrypt: clean
	sops -d pki/private/ca.key.enc > pki/private/ca.key
	sops -d pki/private/ca.pass.enc > pki/private/ca.pass

isNameDefined:
	if [ -z "$(name)" ]; then echo "Missing argument name=<username>"; exit 1 ; fi

request: isNameDefined
	./easyrsa gen-req $(name)
	git add pki/reqs/$(name)
	git commit pki/reqs/$(name) -m 'Submit certificate request for $(name)'
	git push origin

revoke: isNameDefined decrypt
	./easyrsa revoke $(name)
	./easyrsa gen-crl
	if [ -f pki/reqs/$(name).req ]; then git rm pki/reqs/$(name).req; fi
	if [ -f pki/issued/$(name).crt ]; then git rm pki/issued/$(name).crt; fi
	git add pki/crl.pem pki/index.txt
	git commit -m "Revoked cert for $(name)"
#	git push origin
	make clean

show-req: isNameDefined
	./easyrsa show-req $(name)

show-cert: isNameDefined
	./easyrsa show-cert $(name)

sign: isNameDefined decrypt
	./easyrsa sign-req client $(name)
	git add pki/issued/$(name)
	git add pki/index.txt pki/serial
	git commit pki/issued/$(name) -m 'Sign certificate request for $(name)'
#	git push origin
	make clean

# Missing Revoking procedure
