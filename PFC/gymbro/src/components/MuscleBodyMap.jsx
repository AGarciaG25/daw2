import { useMemo, useRef, useState } from 'react'
import { maleBodyBack, maleBodyFront, maleBodyOutline } from '../data/maleBodyMapData'
import './MuscleBodyMap.css'

const BODY_VIEWS = {
  front: {
    label: 'Frontal',
    viewBox: '0 0 724 1448',
    parts: maleBodyFront,
    outline: maleBodyOutline.front,
  },
  back: {
    label: 'Posterior',
    viewBox: '724 0 724 1448',
    parts: maleBodyBack,
    outline: maleBodyOutline.back,
  },
}

const BODY_PART_META = {
  abs: { label: 'Abdominales', slugs: ['abdominales', 'core'] },
  adductors: { label: 'Aductores', slugs: ['aductores', 'abductores'] },
  biceps: { label: 'Biceps', slugs: ['biceps'] },
  calves: { label: 'Gemelos', slugs: ['gemelos'] },
  chest: { label: 'Pecho', slugs: ['pectorales', 'pecho'] },
  deltoids: { label: 'Hombros', slugs: ['hombros', 'deltoides'] },
  forearm: { label: 'Antebrazos', slugs: ['antebrazos', 'forearms'] },
  gluteal: { label: 'Gluteos', slugs: ['gluteos'] },
  hamstring: { label: 'Isquiotibiales', slugs: ['isquiotibiales'] },
  'lower-back': { label: 'Lumbar', slugs: ['lumbar'] },
  neck: { label: 'Cuello', slugs: ['trapecios', 'espalda-alta'] },
  obliques: { label: 'Oblicuos', slugs: ['abdominales', 'core'] },
  quadriceps: { label: 'Cuadriceps', slugs: ['cuadriceps'] },
  tibialis: { label: 'Tibial', slugs: ['tibial-anterior', 'tibiales'] },
  trapezius: { label: 'Trapecios', slugs: ['trapecios', 'espalda-alta'] },
  triceps: { label: 'Triceps', slugs: ['triceps'] },
  'upper-back': { label: 'Espalda', slugs: ['dorsales', 'espalda-media', 'espalda'] },
}

const ATLAS_ROWS = [
  {
    label: 'Frontal',
    view: 'front',
    items: [
      'neck',
      'trapezius',
      'deltoids',
      'chest',
      'biceps',
      'triceps',
      'forearm',
      'abs',
      'obliques',
      'adductors',
      'quadriceps',
      'calves',
    ],
  },
  {
    label: 'Posterior',
    view: 'back',
    items: [
      'neck',
      'trapezius',
      'deltoids',
      'upper-back',
      'triceps',
      'forearm',
      'lower-back',
      'gluteal',
      'adductors',
      'hamstring',
      'calves',
    ],
  },
]

const MUSCLE_ZONE_IMAGES = {
  abs: '/muscle-zones/abdominales.png',
  adductors: '/muscle-zones/aductores-laterales.png',
  biceps: '/muscle-zones/biceps.png',
  calves: '/muscle-zones/gemelos-frontal.png',
  chest: '/muscle-zones/pecho.png',
  deltoids: '/muscle-zones/hombros.png',
  forearm: '/muscle-zones/triceps-antebrazo-lateral.png',
  gluteal: '/muscle-zones/gluteos.png',
  hamstring: '/muscle-zones/isquiotibiales.png',
  'lower-back': '/muscle-zones/lumbar.png',
  neck: '/muscle-zones/trapecios-superiores.png',
  obliques: '/muscle-zones/serratos-oblicuos.png',
  quadriceps: '/muscle-zones/cuadriceps.png',
  tibialis: '/muscle-zones/gemelos-frontal.png',
  trapezius: '/muscle-zones/trapecios-superiores.png',
  triceps: '/muscle-zones/triceps-posterior.png',
  'upper-back': '/muscle-zones/dorsales.png',
}

function getPartMeta(part) {
  return BODY_PART_META[part.slug] || null
}

function getPartPaths(part) {
  return [
    ...(part.path?.common || []),
    ...(part.path?.left || []),
    ...(part.path?.right || []),
  ]
}

function getAvailableGroups(part, muscleGroups) {
  const meta = getPartMeta(part)
  if (!meta) return []

  return meta.slugs
    .map((slug) => muscleGroups.find((group) => group.slug === slug))
    .filter((group) => group && group.exercise_count > 0)
}

function getPreferredGroup(part, muscleGroups) {
  return getAvailableGroups(part, muscleGroups)[0] || null
}

function isPartActive(part, selectedMuscleSlug) {
  const meta = getPartMeta(part)
  return Boolean(meta?.slugs.includes(selectedMuscleSlug))
}

function findPart(view, slug) {
  return BODY_VIEWS[view].parts.find((part) => part.slug === slug) || null
}

function renderPath(path, className, key) {
  return <path key={key} className={className} d={path} vectorEffect="non-scaling-stroke" />
}

function BodySvg({ view, muscleGroups, selectedMuscleSlug, onPartSelect, hoveredPartKey, onPartHover, className = '' }) {
  const definition = BODY_VIEWS[view]

  return (
    <svg
      viewBox={definition.viewBox}
      className={`body-map__figure body-map__figure--${view} ${className}`.trim()}
      preserveAspectRatio="xMidYMid meet"
      shapeRendering="geometricPrecision"
      role="img"
      aria-label={`Mapa muscular masculino ${definition.label.toLowerCase()}`}
    >
      <g className={`body-map__artwork body-map__artwork--${view}`}>
        <path className="body-map__outline" d={definition.outline} vectorEffect="non-scaling-stroke" />

        {definition.parts.map((part) => {
          const meta = getPartMeta(part)
          const availableGroup = getPreferredGroup(part, muscleGroups)
          const isActive = isPartActive(part, selectedMuscleSlug)
          const partKey = `${view}:${part.slug}`
          const partClassName = [
            'body-map__zone',
            availableGroup ? 'body-map__zone--available' : 'body-map__zone--disabled',
            isActive ? 'body-map__zone--active' : '',
            hoveredPartKey === partKey ? 'body-map__zone--hovered' : '',
          ].filter(Boolean).join(' ')

          return (
            <g
              key={partKey}
              tabIndex={availableGroup ? 0 : -1}
              role={availableGroup ? 'button' : 'img'}
              aria-label={
                availableGroup
                  ? `Filtrar por ${meta.label}`
                  : `${meta?.label || part.slug} sin ejercicios`
              }
              onClick={() => availableGroup && onPartSelect(part)}
              onKeyDown={(event) => {
                if (!availableGroup) return
                if (event.key === 'Enter' || event.key === ' ') {
                  event.preventDefault()
                  onPartSelect(part)
                }
              }}
              onMouseEnter={() => onPartHover(partKey)}
              onMouseLeave={() => onPartHover('')}
              onFocus={() => onPartHover(partKey)}
              onBlur={() => onPartHover('')}
            >
              <title>
                {availableGroup
                  ? `${meta.label} - ${availableGroup.exercise_count} ejercicios`
                  : meta?.label || part.slug}
              </title>
              {getPartPaths(part).map((path, index) => renderPath(path, partClassName, `${partKey}-${index}`))}
            </g>
          )
        })}
      </g>
    </svg>
  )
}

function MuscleAtlasFigure({ view, part, isActive }) {
  const imageSrc = MUSCLE_ZONE_IMAGES[part.slug]

  if (imageSrc) {
    return (
      <img
        src={imageSrc}
        alt=""
        className={`body-map__atlas-image ${isActive ? 'body-map__atlas-image--active' : ''}`}
        loading="lazy"
      />
    )
  }

  return (
    <svg viewBox={BODY_VIEWS[view].viewBox} className="body-map__atlas-figure" aria-hidden="true">
      <path className="body-map__outline" d={BODY_VIEWS[view].outline} vectorEffect="non-scaling-stroke" />
      {getPartPaths(part).map((path, index) =>
        renderPath(
          path,
          `body-map__zone body-map__zone--available ${isActive ? 'body-map__zone--active' : 'body-map__zone--hovered'}`,
          `atlas-${view}-${part.slug}-${index}`
        )
      )}
    </svg>
  )
}

function MuscleBodyMap({ muscleGroups, selectedMuscleSlug, onMuscleToggle, onClear }) {
  const [hoveredPartKey, setHoveredPartKey] = useState('')
  const atlasGridRef = useRef(null)
  const atlasDragRef = useRef({
    active: false,
    moved: false,
    startX: 0,
    scrollLeft: 0,
  })

  const availableCount = useMemo(
    () =>
      Object.values(BODY_VIEWS)
        .flatMap((definition) => definition.parts)
        .filter((part) => getAvailableGroups(part, muscleGroups).length > 0).length,
    [muscleGroups]
  )

  const atlasRows = useMemo(() => {
    const seenGroupSlugs = new Set()

    return ATLAS_ROWS.map((row) => ({
      ...row,
      cards: row.items
        .map((slug) => {
          const part = findPart(row.view, slug)
          const availableGroups = part ? getAvailableGroups(part, muscleGroups) : []
          const preferredGroup = availableGroups[0] || null
          const exerciseCount = availableGroups.reduce((total, group) => total + group.exercise_count, 0)
          return { atlasView: row.view, part, availableGroups, preferredGroup, exerciseCount }
        })
        .filter((item) => {
          if (!item.part || !item.preferredGroup) return false
          if (seenGroupSlugs.has(item.preferredGroup.slug)) return false

          seenGroupSlugs.add(item.preferredGroup.slug)
          return true
        }),
    }))
  }, [muscleGroups])

  function handlePartSelect(part) {
    const availableGroup = getPreferredGroup(part, muscleGroups)
    if (!availableGroup) return
    if (isPartActive(part, selectedMuscleSlug)) return onClear()
    onMuscleToggle(availableGroup)
  }

  function handleAtlasPointerDown(event) {
    if (event.button !== 0) return
    const grid = atlasGridRef.current
    if (!grid || grid.scrollWidth <= grid.clientWidth) return

    atlasDragRef.current = {
      active: true,
      moved: false,
      startX: event.clientX,
      scrollLeft: grid.scrollLeft,
    }
    grid.classList.add('body-map__atlas-grid--dragging')
    grid.setPointerCapture?.(event.pointerId)
  }

  function handleAtlasPointerMove(event) {
    const drag = atlasDragRef.current
    const grid = atlasGridRef.current
    if (!drag.active || !grid) return

    const distance = event.clientX - drag.startX
    if (Math.abs(distance) > 4) {
      drag.moved = true
    }
    grid.scrollLeft = drag.scrollLeft - distance
  }

  function stopAtlasDrag(event) {
    const grid = atlasGridRef.current
    if (grid) {
      grid.classList.remove('body-map__atlas-grid--dragging')
      grid.releasePointerCapture?.(event.pointerId)
    }
    atlasDragRef.current.active = false
  }

  function handleAtlasClickCapture(event) {
    if (!atlasDragRef.current.moved) return
    event.preventDefault()
    event.stopPropagation()
    atlasDragRef.current.moved = false
  }

  return (
    <section className="body-map">
      <div className="body-map__panel">
        <div className="body-map__figures">
          {Object.entries(BODY_VIEWS).map(([value, definition]) => (
            <div key={value} className="body-map__viewport">
              <div className="body-map__viewport-header">
                <span className="body-map__legend-label">Vista</span>
                <strong>{definition.label}</strong>
              </div>
              <BodySvg
                view={value}
                muscleGroups={muscleGroups}
                selectedMuscleSlug={selectedMuscleSlug}
                onPartSelect={handlePartSelect}
                hoveredPartKey={hoveredPartKey}
                onPartHover={setHoveredPartKey}
              />
            </div>
          ))}
        </div>

        <div className="body-map__legend">
          <div className="body-map__legend-card">
            <span className="body-map__legend-label">Cuerpo</span>
            <strong>Frente y espalda</strong>
            <small>{availableCount} zonas disponibles en total</small>
          </div>

          <div className="body-map__legend-scale">
            <span><i className="body-map__dot body-map__dot--active" /> Seleccionada</span>
            <span><i className="body-map__dot body-map__dot--available" /> Disponible</span>
            <span><i className="body-map__dot body-map__dot--disabled" /> Sin ejercicios</span>
          </div>

          <button type="button" className="button button--ghost" onClick={onClear}>
            Limpiar zona
          </button>
        </div>
      </div>

      <div
        className="body-map__atlas-grid"
        ref={atlasGridRef}
        onClickCapture={handleAtlasClickCapture}
        onPointerDown={handleAtlasPointerDown}
        onPointerMove={handleAtlasPointerMove}
        onPointerUp={stopAtlasDrag}
        onPointerCancel={stopAtlasDrag}
        onPointerLeave={stopAtlasDrag}
      >
        {atlasRows.flatMap((row) =>
          row.cards.map(({ atlasView, part, availableGroups, exerciseCount }) => {
            const meta = getPartMeta(part)
            const isActive = isPartActive(part, selectedMuscleSlug)
            return (
              <button
                key={`${atlasView}-${part.slug}`}
                type="button"
                className={`body-map__atlas-card ${isActive ? 'body-map__atlas-card--active' : ''}`}
                onClick={() => availableGroups.length && handlePartSelect(part)}
                disabled={!availableGroups.length}
              >
                <MuscleAtlasFigure view={atlasView} part={part} isActive={isActive} />
                <div className="body-map__atlas-copy">
                  <strong>{meta.label}</strong>
                  <span>{exerciseCount} ejercicios</span>
                </div>
              </button>
            )
          })
        )}
      </div>
    </section>
  )
}

export default MuscleBodyMap
