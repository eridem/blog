# http://eridem.net

Code for the blog <http://eridem.net>.

## Licenses

- Forked and deatached from project BlackrockDigital/startbootstrap-clean-blog-jekyll:
  - **Repository**: https://github.com/BlackrockDigital/startbootstrap-clean-blog-jekyll
  - **License**:    https://github.com/BlackrockDigital/startbootstrap-clean-blog-jekyll/blob/9fb9dbfce7d8d2625acee9f079121998992e45d7/LICENSE

## Troubleshooting

*Windows* installation:

- Download and install <https://dl.bintray.com/oneclick/rubyinstaller/rubyinstaller-2.2.6-x64.exe>
- Download and install in `C:\RubyDevKit` <https://dl.bintray.com/oneclick/rubyinstaller/DevKit-mingw64-64-4.7.2-20130224-1432-sfx.exe>
- Add `C:\Ruby22-x64\bin` to your path.
- Go to `C:\RubyDevKit` and execute:
  ```sh
  ruby.exe dk.rb init
  ruby.exe dk.rb install
  ```
- Go to the project and execute:
  ```sh
  yarn
  yarn grunt
  yarn build
  yarn start
  ```