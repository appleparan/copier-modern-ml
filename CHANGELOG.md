## [0.9.1] - 2025-03-05

### Bug Fixes

- Move tests/ outside of src/ ([80241e8](https://github.com/appleparan/copier-modern-ml/commit/80241e8cd2ffed70d7c8b4e4a29c33fe737c86f1))
- Fix mistypo ([4b7f5bf](https://github.com/appleparan/copier-modern-ml/commit/4b7f5bf9b3279ad9c8fb66f00d1e2b72b7ff463d))

## [0.9.0] - 2025-02-15

### Bug Fixes

- Replace REPO url in cliff.toml ([add7473](https://github.com/appleparan/copier-modern-ml/commit/add7473df3313a8dfba6fddf6aade6c4c807d320))
- Add project URLs ([b3cd2cd](https://github.com/appleparan/copier-modern-ml/commit/b3cd2cd707d57e7da2948d2b398f6ee96ab735a7))
- Update pre-commit hook versions ([1d37efa](https://github.com/appleparan/copier-modern-ml/commit/1d37efab87e698cade0174638300ba433cd255ed))
- Update minimum uv version to 0.6.0 ([134e70c](https://github.com/appleparan/copier-modern-ml/commit/134e70c1a356d6dfe07271f948b4d203822749a9))
- Add answers for test ([90b96aa](https://github.com/appleparan/copier-modern-ml/commit/90b96aa48cb5baa887e17cb758b2e8ad03c331e0))
- Escape some Jinja part in project's cliff.toml ([84cc4fc](https://github.com/appleparan/copier-modern-ml/commit/84cc4fcba60eb146d4208ad9080204635a6adf2b))

### Documentation

- Update project template README ([fff75db](https://github.com/appleparan/copier-modern-ml/commit/fff75db37dfc7810cd65ee3cef1b0d7a6990801a))
- Update README ([84b0248](https://github.com/appleparan/copier-modern-ml/commit/84b0248b869363041bc5824ca8d0e0dca9e581b9))

### Features

- Use repo URL to link for commit in RELEASE note generation ([8c0926d](https://github.com/appleparan/copier-modern-ml/commit/8c0926d408753ac2a2099b9119ff03b48874d4ad))
- Support allow-insecure-host for custom CA certificates envs. ([37b86c3](https://github.com/appleparan/copier-modern-ml/commit/37b86c36bed613a7a9eeb21d9d9735d0e43e2ce5))

### Miscellaneous Tasks

- Bump version to 0.9.0 ([26f2a3b](https://github.com/appleparan/copier-modern-ml/commit/26f2a3bbb889c2e7eea4252c33adbab315b606d9))

## [0.8.0] - 2025-01-31

### Bug Fixes

- Fix GitLab CI syntax error ([2a07b85](https://github.com/appleparan/copier-modern-ml/commit/2a07b8502e53ca0eeec50f1b321c1a56c05dd418))
- Drop support CUDA 12.1 and add CUDA 12.6 support ([ee2f2fc](https://github.com/appleparan/copier-modern-ml/commit/ee2f2fc9e9f9f4f9c8d4246a65ba9b08cb68fa92))

### Documentation

- Update README ([b21949f](https://github.com/appleparan/copier-modern-ml/commit/b21949f6bcf6bfa620f6ceb4a72e764132414f03))

### Features

- Add yaml file for GitLab CI (using uv) ([e5245cf](https://github.com/appleparan/copier-modern-ml/commit/e5245cf01f8a02105cc7ec6dd5e9abd8d6828c3e))
- Bump version feature on release ([3b3ccce](https://github.com/appleparan/copier-modern-ml/commit/3b3ccce6dd3b1dea3da558bee0f7e2fce1a927ab))

### Miscellaneous Tasks

- Update torch to 2.6.0 in project ([d0fd403](https://github.com/appleparan/copier-modern-ml/commit/d0fd40317ad2f505df71517cad2414f1753463a4))
- Make release script POSIX-compliant by using /bin/sh ([a4bb08b](https://github.com/appleparan/copier-modern-ml/commit/a4bb08b27499ffca1e1eaa00e1e184050b2fe127))
- Bump version ([7539c17](https://github.com/appleparan/copier-modern-ml/commit/7539c17343861230dbfc10b62f3010cec4694726))
- Fix non POSIX-complaint script ([e3e315e](https://github.com/appleparan/copier-modern-ml/commit/e3e315ecda416a442b13a12df31c62253f670b04))
- Bump version to 0.8.0 ([1370af1](https://github.com/appleparan/copier-modern-ml/commit/1370af11e77c2916184148ac9cb7d8f7d363edb8))

### Build

- Update git-cliff ([b012bca](https://github.com/appleparan/copier-modern-ml/commit/b012bcada95f1f9a0df8a653c79285065bd4ecc0))
- Update lock file ([ad7dd93](https://github.com/appleparan/copier-modern-ml/commit/ad7dd93b8e226aeef67134ca9ef7fea0b2d0bf01))
- Drop support Python 3.11 ([db0884a](https://github.com/appleparan/copier-modern-ml/commit/db0884a814d9c50620ea3a286fa1ec74c9f57f43))

## [0.7.0] - 2025-01-27

### Bug Fixes

- Use Hydra Compose API to load config manually ([6b965f5](https://github.com/appleparan/copier-modern-ml/commit/6b965f5be2ca64ced27a0132fe5cf7b84c5c11ee))
- Fix GitHub Actions mistypos ([d5b304e](https://github.com/appleparan/copier-modern-ml/commit/d5b304e6beda87f9c7a483ad4b85e966c8fadece))
- Lint example code ([c00075e](https://github.com/appleparan/copier-modern-ml/commit/c00075e26b14968142f6f1e72021b47c4ba4f465))

### Documentation

- Add CHANGELOG.md and RELEASE.md to release v0.7.0 ([afc74f8](https://github.com/appleparan/copier-modern-ml/commit/afc74f82f2312c3a7f0245cdf059f5ba6a691149))

### Features

- Add script for GitHub release ([2caa501](https://github.com/appleparan/copier-modern-ml/commit/2caa5013cbcac70b602e090f5370d4a64dca6bb6))

### Miscellaneous Tasks

- Fix release.sh to push commits correctly ([22b28ea](https://github.com/appleparan/copier-modern-ml/commit/22b28ea8858f0a99d6071cdd9b730d6bdb3a1a9e))

### Build

- Add "v" prefix to version tags ([4ef96c4](https://github.com/appleparan/copier-modern-ml/commit/4ef96c4905f414e6b0294fcec39ec57377816b24))

## [0.6.1] - 2025-01-11

### Bug Fixes

- Normalize platform_system to sys_platform ([f3bb2f5](https://github.com/appleparan/copier-modern-ml/commit/f3bb2f5535f5f87b5d9a05d69e6c32e596fd9811))
- Add sympy v1.13.1 ([31fb501](https://github.com/appleparan/copier-modern-ml/commit/31fb5017d16e9f2b084eea90ac8de8aa964d50ed))
- Update README ([0df6531](https://github.com/appleparan/copier-modern-ml/commit/0df6531f8281f95481d5031c159963ad28ef0906))

### Documentation

- Update README ([10debe2](https://github.com/appleparan/copier-modern-ml/commit/10debe2093e3cf273964098dbffcdcd915819956))
- Update README (project) ([4ec4cd6](https://github.com/appleparan/copier-modern-ml/commit/4ec4cd6c6c57d752bce41c8daea422409ba78eb6))
- Update README ([7513096](https://github.com/appleparan/copier-modern-ml/commit/75130967dd8b408841203a646cfc2dd5a7142891))
- Add CHANGELOG.md and RELEASE.md to release v0.6.1 ([3cb9c63](https://github.com/appleparan/copier-modern-ml/commit/3cb9c63452bc701aed322fbe9726da0e56cf1183))

### Miscellaneous Tasks

- Update astral-sh/setup-uv action to v5 ([0489c3d](https://github.com/appleparan/copier-modern-ml/commit/0489c3d2749966229739f567d1b340dcdbba3d53))

## [0.6.0] - 2024-12-10

### Bug Fixes

- Update some pyproject.toml configs ([c837b08](https://github.com/appleparan/copier-modern-ml/commit/c837b087dbf3ea0e1b23e95f30e3264375fa64f4))
- Fix mistypo ([36bece1](https://github.com/appleparan/copier-modern-ml/commit/36bece10b90c72ff2facb0b75ebe204b92a29213))
- Remove removed ruff rules ([c6f39a1](https://github.com/appleparan/copier-modern-ml/commit/c6f39a17b64b283cd327625da861cf3e1cfdb667))
- Remove deprecated rule on recent ruff version ([3258ba8](https://github.com/appleparan/copier-modern-ml/commit/3258ba82fa556ccd82dfc4320454a6f6f0f96121))
- Add constraint for lightning ([b8470c5](https://github.com/appleparan/copier-modern-ml/commit/b8470c5af66e0c108ad472fce732f07602b1a346))
- Add more ruff rules ([3b0f8bd](https://github.com/appleparan/copier-modern-ml/commit/3b0f8bd2112610e1a4972802337e803e34a0bc9f))

### Documentation

- Update CHANGELOG for version 0.5.1 ([b33cd85](https://github.com/appleparan/copier-modern-ml/commit/b33cd85222ca8aa2bd59d3779123891c67c32a10))
- Disable emoji support ([eb1694b](https://github.com/appleparan/copier-modern-ml/commit/eb1694bb6739edea8f03fa56acb22ff4931a2880))
- Update README ([596e351](https://github.com/appleparan/copier-modern-ml/commit/596e3511da6cf5fabeb444903c09db1da3432600))
- Update README ([61142c4](https://github.com/appleparan/copier-modern-ml/commit/61142c4a088a1743ff4ccbfa314d9a69b72685cf))
- Update CHANGELOG for version refs/tags/v0.6.0 ([9b5601a](https://github.com/appleparan/copier-modern-ml/commit/9b5601ae4af07a9d353f30497b545ba559699bb9))
- Add CHANGELOG.md and RELEASE.md to release v0.6.1 ([19cb91d](https://github.com/appleparan/copier-modern-ml/commit/19cb91d4bf3430a58dbff8ed6322c4c73dee0e5c))
- Add commit CHANGELOG and RELEASE in release.sh ([6e33188](https://github.com/appleparan/copier-modern-ml/commit/6e3318838599be1a7897fc629b1b279399ee841b))
- Add CHANGELOG.md and RELEASE.md to release v0.6.0 ([ecf434b](https://github.com/appleparan/copier-modern-ml/commit/ecf434b2c7c300dc16246c77bb491ebd99e1e621))
- Add CHANGELOG.md and RELEASE.md to release v0.6.0 ([9493657](https://github.com/appleparan/copier-modern-ml/commit/949365761bc43fa36b7555ad657fd9154444fb90))
- Add CHANGELOG.md and RELEASE.md to release v0.6.0 ([bf78045](https://github.com/appleparan/copier-modern-ml/commit/bf78045b517fac374248d72dd90786fff3f19f80))

### Features

- Add sample ML training code ([06ac3d6](https://github.com/appleparan/copier-modern-ml/commit/06ac3d6d708a8de92741290169b38cdff309b678))

### Miscellaneous Tasks

- Increase heading level in README template ([729d3cc](https://github.com/appleparan/copier-modern-ml/commit/729d3cc695d0c6c74b02a51e7cf563c8a5b172dc))
- Replace deprecated `set-output` with `$GITHUB_OUTPUT` in GitHub CI ([b2b0c57](https://github.com/appleparan/copier-modern-ml/commit/b2b0c576826e2be87e51670c92e2b60247ffc6b9))
- Support macos-latest and windows-latest ([7a6bc6e](https://github.com/appleparan/copier-modern-ml/commit/7a6bc6e3b2f5b672f8d683cf277437719e635ea4))
- Add more pytorch sources ([959698b](https://github.com/appleparan/copier-modern-ml/commit/959698b13aa113b029f55129dcc7c7f2e5a1c3c7))
- Set python version defined by setup-uv ([a5df034](https://github.com/appleparan/copier-modern-ml/commit/a5df0344860502481422e970df207714f965f588))
- Use groups rather than dev dependenciese ([d06bc4e](https://github.com/appleparan/copier-modern-ml/commit/d06bc4e220333952d38ef05d533bc01365d05649))
- Revert use python-version in setup-uv ([abffffd](https://github.com/appleparan/copier-modern-ml/commit/abffffdf697de43b0c4f11b8fdb97e21a227ad8c))
- Add Powershell script for test ([cd050b6](https://github.com/appleparan/copier-modern-ml/commit/cd050b6bd72c861927a4b0d599b3994b3af3ca81))
- Bump version ([2da3e1c](https://github.com/appleparan/copier-modern-ml/commit/2da3e1c3c7f1b20180a08f9096d27ea6db3dd370))
- Rollback to tag based release system ([876b8c0](https://github.com/appleparan/copier-modern-ml/commit/876b8c000ad22d2a5a9d01ea3678c764a5c2b4da))
- Simplify release process ([2c210f5](https://github.com/appleparan/copier-modern-ml/commit/2c210f514ecb12067cd7706272fc1313d690a163))
- Bump version ([f2620f6](https://github.com/appleparan/copier-modern-ml/commit/f2620f67150a7afac55341da28f584b2dde60339))
- Bump version for re-release ([35ee026](https://github.com/appleparan/copier-modern-ml/commit/35ee0269643c2d55e4c326739e4313ee631dbc76))
- Proper RELEASE.md generation ([4e50974](https://github.com/appleparan/copier-modern-ml/commit/4e509743e697f7533ae77203bd6b7694aa9982cf))

### Build

- Support conflicts from uv 0.5.4 for PyTorch ([91647e1](https://github.com/appleparan/copier-modern-ml/commit/91647e13532a52c03c039b93a0a598d1398ccb16))
- Update git-cliff version ([ac9b8a7](https://github.com/appleparan/copier-modern-ml/commit/ac9b8a7b5a68471b0b323301529d00d16d3b0970))
- Fix TOML syntax error due to pytest configuration ([ee45627](https://github.com/appleparan/copier-modern-ml/commit/ee4562750956b6f4c207000b4fac7a5faa3e21c6))
- Add version constraint (a lower bound) for dev packages ([92cdb61](https://github.com/appleparan/copier-modern-ml/commit/92cdb61e79338b589d1df92afa3f0600d9d1a29b))
- Move ipykernel to dev groups ([3f986e5](https://github.com/appleparan/copier-modern-ml/commit/3f986e5182940478565a1ca4e3f46d5a0cd81276))
- Add more version constraints ([9314032](https://github.com/appleparan/copier-modern-ml/commit/9314032ca3f1f5c276dac6beaebc5491e140316c))
- Remove pypi index for default pytorch installation ([4abcc74](https://github.com/appleparan/copier-modern-ml/commit/4abcc74513508cd6c6dfdc2e013ea6114a5c4b2f))

## [0.5.1] - 2024-09-19

### Documentation

- Update CHANGELOG for version 0.5.0 ([4975931](https://github.com/appleparan/copier-modern-ml/commit/49759319b5ba24b442d3f478d3d41357ff8561f4))

### Miscellaneous Tasks

- Fix failed push error ([0588bda](https://github.com/appleparan/copier-modern-ml/commit/0588bda808674f2cc105fe9ffad6776daa6d19ba))

## [0.5.0] - 2024-09-19

### Documentation

- Update CHANGELOG for version ([ad1f2e1](https://github.com/appleparan/copier-modern-ml/commit/ad1f2e13c33de5c996a9ee5625ba751836c17b44))

### Features

- Drop rye, use uv instead ([705047d](https://github.com/appleparan/copier-modern-ml/commit/705047d233434b6039e58b304305eab1ed2f5889))

### Miscellaneous Tasks

- Bump version to 0.4.6 ([a75ed96](https://github.com/appleparan/copier-modern-ml/commit/a75ed963937621c6ce1fa010f3d5476f54796b75))
- Include "Bump to vX.X.X" into vX.X.X ([d87fa33](https://github.com/appleparan/copier-modern-ml/commit/d87fa33e0f96519bc5fedfe2e57c04fb5964bf8c))
- Trigger release by branches ([44f2def](https://github.com/appleparan/copier-modern-ml/commit/44f2def1fc678522d2a49f9a09fbf9a973e2310b))
- Fix GitHub release not generated ([5a02b7e](https://github.com/appleparan/copier-modern-ml/commit/5a02b7e73b00e6ef6dffe7b3178f72d23df3c2f6))
- Bump version to 0.5.1 ([ea4c0a2](https://github.com/appleparan/copier-modern-ml/commit/ea4c0a21a5fa2984fbf5b1047d45797e65b8ff5d))
- Pull before bump version ([8d7c2fc](https://github.com/appleparan/copier-modern-ml/commit/8d7c2fcd83a1a94ba95fe232ba3faf62353728c1))
- Trigger release by branch in template GitHub Action ([d580ec2](https://github.com/appleparan/copier-modern-ml/commit/d580ec20d6b0d399e0446c77e323520235f711de))
- Bump version to 0.5.0 ([6c73068](https://github.com/appleparan/copier-modern-ml/commit/6c73068141262285933e0fd8a0a9d6c56aee5755))

## [0.4.6] - 2024-09-16

### Documentation

- Update CHANGELOG for version ([bb1ea0d](https://github.com/appleparan/copier-modern-ml/commit/bb1ea0d8eae250eaa9345493d53679dae9f983c2))

### Miscellaneous Tasks

- Bump version to 0.4.3 ([193c9e3](https://github.com/appleparan/copier-modern-ml/commit/193c9e3eff96d28a55b66ff0b98f8fad561587fb))
- Bump version to 0.4.4 ([e4edba5](https://github.com/appleparan/copier-modern-ml/commit/e4edba596cfdd8e97dd8f2eed4602692d61dd4cb))
- Push CHANGELOG.md origin and main branch ([d811440](https://github.com/appleparan/copier-modern-ml/commit/d811440c1efe93a21f5e31732b499b1e0d98c7e6))
- Checkout branch as main in GitHub Actions ([36cdced](https://github.com/appleparan/copier-modern-ml/commit/36cdced9292c21f75de1ffda6c3e45b966bbcddb))
- Generate release note automatically ([499f622](https://github.com/appleparan/copier-modern-ml/commit/499f622254324c7d3acce6c8c38960a2c18cb84b))
- Generate CHANGELOG.md from v0.3.0 ([b63fa47](https://github.com/appleparan/copier-modern-ml/commit/b63fa47457673f085c6b4db35720fab1c695a3fd))
- Separate CHANGELOG.md and RELEASE.md ([48267c6](https://github.com/appleparan/copier-modern-ml/commit/48267c623d019fbd17df6b5148d78214bb26656c))
- Add set +e due to nothing to commit error ([820f1d8](https://github.com/appleparan/copier-modern-ml/commit/820f1d8b6de15d8d75fa2e8af062a0b19650b4b5))

## [0.4.0] - 2024-09-16

### Bug Fixes

- Fix missing package error (duty) ([8eab7ca](https://github.com/appleparan/copier-modern-ml/commit/8eab7caaa6739dab01aa22aad1f57e147ea18ad7))
- Use single-quote format ([081dd00](https://github.com/appleparan/copier-modern-ml/commit/081dd0081e942da45ace0cb4c93ef1ed0b9147ff))
- Update README ([0e5e977](https://github.com/appleparan/copier-modern-ml/commit/0e5e9775125b10daf27fffe829099edde1e9a0b2))
- Disable MD013 in markdownlint ([2fcd2c9](https://github.com/appleparan/copier-modern-ml/commit/2fcd2c9c50d497affe95c995062a97a14ac141d3))

### Documentation

- Update README ([e88c93a](https://github.com/appleparan/copier-modern-ml/commit/e88c93a59ef208f5f6af5d3778ad11541e8d7517))

### Features

- Make project universal (cross-platform) ([994897c](https://github.com/appleparan/copier-modern-ml/commit/994897ce2d8e99c486318133103ac69ee6e5568f))
- Make template for CONTRIBUTING.md ([11c4598](https://github.com/appleparan/copier-modern-ml/commit/11c4598e76eb36b8a16ad3c7f01e513e99db1958))
- Add pre-commit hooks ([0e5d847](https://github.com/appleparan/copier-modern-ml/commit/0e5d8471ba7fce645f7d72f05b9d8482317b10cb))

### Miscellaneous Tasks

- Remove duty ([ee382a3](https://github.com/appleparan/copier-modern-ml/commit/ee382a31540fdace71ec0fbe977e528aa1ae514d))
- Update test codes to run CI correctly ([6727c16](https://github.com/appleparan/copier-modern-ml/commit/6727c16794f6df5cd563bbb86de4499d3826a4a3))
- Add bumpversion setup ([285d883](https://github.com/appleparan/copier-modern-ml/commit/285d883ab1fc835b3c7d7a916fddd56b460eb62f))
- Set git-cliff bump option correctly ([f500eb0](https://github.com/appleparan/copier-modern-ml/commit/f500eb0ca0e4b021740a44fb6ac4af1ff7cbfbff))
- Change GitHub Aciton for Release ([4097e5a](https://github.com/appleparan/copier-modern-ml/commit/4097e5af2a6d8dd1bd72150d83e2db841107fb02))

### Build

- Update git-cliff ([9d4dcba](https://github.com/appleparan/copier-modern-ml/commit/9d4dcbab0c4e92867a319097170b2397fe8ac798))

## [0.3.0] - 2024-08-15

### Documentation

- Update README ([bc4b8c6](https://github.com/appleparan/copier-modern-ml/commit/bc4b8c671809d2a43753b885c36599a305aab135))

### Features

- Setup project-wise git cliff ([6861205](https://github.com/appleparan/copier-modern-ml/commit/6861205881afd901062ae5ccc14481e82b3576d9))

<!-- generated by git-cliff -->
