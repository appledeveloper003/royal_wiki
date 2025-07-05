get:
	flutter pub get

upgrade:
	flutter pub upgrade

build_runner:
	dart run build_runner watch --delete-conflicting-outputs

build_mock:
	dart run build_runner build

sha1:
	cd android && ./gradlew signingReport

run_android:
	flutter run --no-enable-impeller

apk:
	flutter build apk --debug 

aab:
	flutter build appbundle --release

clean:
	flutter clean
	
list:
	@echo make get
	@echo make upgrade
	@echo make build_runner
	@echo make sha1
	@echo make run_android
	@echo make clean
	@echo make build_mock