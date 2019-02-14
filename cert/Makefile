.PHONY: clean encrypt decrypt isNameDefined request revoke show-req show-cert sign

clean: 
	rm pki/private/ca.key
	rm pki/private/ca.pass

encrypt:
	sops -e pki/private/ca.key > pki/private/ca.key.enc
	sops -e pki/private/ca.pass > pki/private/ca.pass.enc

decrypt:
	sops -d pki/private/ca.key.enc > pki/private/ca.key
	sops -d pki/private/ca.pass.enc > pki/private/ca.pass

isNameDefined:
	if [ -z "$(name)" ]; then echo "Missing argument name=<username>"; exit 1 ; fi

request: isNameDefined
	./easyrsa gen-req $(name)
	git add pki/reqs/$(name).req
	git commit pki/reqs/$(name).req -m 'Submit certificate request for $(name)'
	git push origin

revoke: isNameDefined decrypt
	./easyrsa revoke $(name)
	./easyrsa gen-crl
	git add \
		pki/crl.pem \
		pki/index.txt \
		pki/index.txt.attr \
		pki/reqs \
		pki/certs_by_serial \
		pki/issued pki/revoked
	rm pki/index.txt.old
	git commit -m "Revoked cert for $(name)"
	git push origin
	make clean

show-req: isNameDefined
	./easyrsa show-req $(name)

show-cert: isNameDefined
	./easyrsa show-cert $(name)

sign: isNameDefined decrypt
	./easyrsa sign-req client $(name)
	rm pki/index.txt.old pki/index.txt.attr pki/serial.old pki/extensions.temp
	git add pki/issued/$(name).crt pki/index.txt pki/certs_by_serial/ pki/serial
	git commit pki/issued/$(name).crt pki/index.txt pki/serial pki/certs_by_serial/ -m 'Sign certificate request for $(name)'
	git push origin
	make clean

# Missing Revoking procedure
