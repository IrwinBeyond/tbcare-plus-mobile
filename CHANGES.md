# Perubahan Terbaru — Backend & Mobile

## Backend (`backend-tbcare`)
**Branch**: `main`  
**Commit**: `0736d15` — `feat: implement CF expert system with soft saturation for quick check assessment`

### File berubah
| File | Perubahan |
|---|---|
| `TBCareApp/Controllers/AssessmentController.cs` | Tambah endpoint `GET /api/v1/assessment/quick-check-config` dengan `[AllowAnonymous]`, ambil 8 gejala dari `assessment_type_id=1`, baca `scoring_method` & `saturation_k` |
| `TBCareApp/DTOs/AssessmentExecutionDtos.cs` | Tambah `QuickCheckConfigDto`, `QuickCheckQuestionDto`, field `CombinedCF`, `ScoringMethod`, `SaturationK` |
| `TBCareApp/Models/AssessmentType.cs` | Tambah field `ScoringMethod`, `SaturationK`, `ResultUnit` |
| `TBCareApp/Service/DiagnosisService.cs` | Ganti sequential CF combination dengan soft saturation: `CF = 1 - e^(-k × Σweight)`, konversi ke persentase |
| `TBCareApp/Data/seed_quick_check.sql` | (baru) Data seed untuk Quick Check assessment |

---

## Mobile (`tbcare-plus-mobile`)
**Branch**: `feat/remove-page-transitions` → `main`  
**Commit**: `89f1af6` — `feat: integrate CF expert system with soft saturation, guest assessment flow`

### File baru
| File | Fungsi |
|---|---|
| `lib/core/models/assessment_config_models.dart` | Model `QuickCheckConfig`, `QuickCheckQuestion`, `RiskLevelConfig` + fallback |
| `lib/core/services/assessment_api_service.dart` | Fetch config dari backend, fallback saat unreachable |
| `lib/core/services/guest_assessment_service.dart` | Simpan/baca hasil assessment guest ke SharedPreferences |

### File berubah
| File | Perubahan |
|---|---|
| `lib/core/constants/app_constants.dart` | Tambah `quickCheckConfig` URL & `keyGuestAssessment` |
| `lib/features/home/pages/home_page.dart` | Fetch 8 gejala dari backend, CF soft saturation, persentase real-time, validasi minimal 1 gejala, warna toggle tetap |
| `lib/features/result/pages/result_page.dart` | Baca data dari SharedPreferences (primer) / route args (fallback), tombol lanjutan untuk MEDIUM/HIGH |
| `lib/features/history/pages/history_page.dart` | Blokir halaman history untuk guest |
| `lib/features/auth/pages/login_page.dart` | Perbaikan guest detection |
| `lib/features/auth/pages/cover_page.dart` | Perbaikan navigasi guest |
| `lib/features/profile/pages/profile_page.dart` | Perbaikan tampilan guest |
| `lib/core/widgets/guest_bottom_nav.dart` | Handle index `-1` (tidak ada item tersorot) |
| `lib/core/widgets/home_header.dart` | Dukungan mode guest |

---

## Rumus Scoring
```
CF_final = 1 - e^(-k × Σ(weight_i))
percentage = CF_final × 100
```
- `k = 0.35` (dari tabel `assessment_types.saturation_k`)
- `weight_i` = nilai CF dari `risk_rules` (-1.0 s/d 1.0)
- `percentage` 0-100, dicocokkan dengan `risk_levels`
