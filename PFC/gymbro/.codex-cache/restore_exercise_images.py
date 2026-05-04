from pathlib import Path
from django.utils.text import slugify
from workouts.models import Exercise

asset_root = Path(r'C:\Users\adry_\Desktop\git\daw2\PFC\gymbro\backend\workouts\static\workouts\exercises')
updated = 0
with_images = 0

for exercise in Exercise.objects.all():
    external_id = exercise.external_id or ''
    base_slug = slugify(external_id) if external_id else ''
    gif_path = ''
    frame_paths = []

    if external_id:
        gif_file = asset_root / f'{external_id}.gif'
        if gif_file.exists():
            gif_path = f'workouts/exercises/{external_id}.gif'

        if base_slug:
            frames = sorted(asset_root.glob(f'{base_slug}-*.jpg')) + sorted(asset_root.glob(f'{base_slug}-*.png'))
            frame_paths = [f'workouts/exercises/{path.name}' for path in frames]

    changed = False
    if exercise.demo_gif_path != gif_path:
        exercise.demo_gif_path = gif_path
        changed = True
    if (exercise.demo_frame_paths or []) != frame_paths:
        exercise.demo_frame_paths = frame_paths
        changed = True

    if changed:
        exercise.save(update_fields=['demo_gif_path', 'demo_frame_paths', 'updated_at'])
        updated += 1
    if gif_path or frame_paths:
        with_images += 1

print('updated', updated)
print('with_images', with_images)
