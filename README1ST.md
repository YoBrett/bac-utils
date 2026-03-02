# README1ST.md - Decryption & Installation Instructions

######################################################################################
## PROGRAM   : README1ST.md
## PROGRAMER : Brett Collingwood
## EMAIL-1   : brett@amperecomputing.com
## EMAIL-2   : brett.a.collingwood@gmail.com
## MUSE      : Kit
## VERSION   : 1.0.0
## DATE      : 2026-02-26
## PURPOSE   : Instructions for decrypting and installing the encrypted bac-utils
##           : package.
## #---------------------------------------------------------------------------------#
## THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
## INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
## PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
## HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
## OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
## SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
######################################################################################

## 1. Verify Integrity
First, verify that the downloaded `.tar.gz.gpg` file matches the provided checksum.

```bash
sha256sum -c __BUILD_FILENAME__.tar.gz.gpg.sha256
```
(You should see `__BUILD_FILENAME__.tar.gz.gpg: OK`)

## 2. Decrypt the Archive
Decrypt the file using GPG. You will be prompted for the password provided securely.

```bash
gpg -d -o __BUILD_FILENAME__.tar.gz __BUILD_FILENAME__.tar.gz.gpg
```
(Enter the password when prompted.)

## 3. Extract & Install
Extract the contents and run the installation script.

```bash
tar -xzf __BUILD_FILENAME__.tar.gz
sudo ./bac-utils.sh
```

---
*Note: If you do not have the password, please contact the project maintainer.*
