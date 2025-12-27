import { useEffect, useState, type PropsWithChildren } from 'react'
import { createPortal } from 'react-dom'
import {
  motion,
  type LegacyAnimationControls,
  type TargetAndTransition,
  type VariantLabels,
} from 'framer-motion'
import type { Placement } from '@/types/Placement'

export default function Portal({
  id,
  placement,
  children,
  state = true,
  animation,
  className = '',
}: PropsWithChildren<{
  id: string
  placement: Placement
  state?: boolean
  animation?: {
    layout?: boolean
    initial?: boolean | TargetAndTransition | VariantLabels
    animate?: boolean | TargetAndTransition | VariantLabels | LegacyAnimationControls
    exit?: TargetAndTransition | VariantLabels
  }
  className?: string
}>) {
  const [target, setTarget] = useState<HTMLElement | null>(null)

  useEffect(() => {
    const el = document.getElementById(placement)
    if (el) {
      setTarget(el)
    } else {
      console.warn(`Portal target #${placement} not found!`)
    }
  }, [placement])

  if (!target) return null

  return createPortal(
    state && (
      <motion.section
        key={id}
        layout={animation?.layout}
        initial={animation?.initial}
        animate={animation?.animate}
        exit={animation?.exit}
        className={className}
      >
        {children}
      </motion.section>
    ),
    target
  )
}
