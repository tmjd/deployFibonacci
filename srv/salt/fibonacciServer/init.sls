
fibonacciServer_bin:
    file:
        - managed
        - name: /usr/bin/fibonacciServer
        - source: salt://fibonacciServer/fibonacciServer
        - user: root
        - group: root
        - mode: 550

fibonacciServer_systemd:
    file:
        - managed
        - name: /etc/systemd/system/fibonacciServer.service
        - source: salt://fibonacciServer/fibonacciServer.service
        - user: root

fibonacciServer_service:
    service:
        - running
        - name: fibonacciServer
        - watch:
            - file: fibonacciServer_bin
            - file: fibonacciServer_systemd
