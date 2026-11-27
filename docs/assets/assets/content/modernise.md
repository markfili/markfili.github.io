<!-- Facts are from the geodetski-portal and planinarski-portal READMEs,
MIGRATION-NOTES.md, BUGS.md and the migration template's README; checked
against them on 2026-11-28. -->

# Modernising legacy apps

Your app still works, but it runs on Python 2, an old Django or a frontend
nobody wants to touch, and every change feels risky. I bring it onto a
current stack **step by step, with every feature kept one to one**, and it
comes out with a modern look and fewer bugs than it went in with.

## AI-assisted, not vibe-coded

AI coding agents make a large migration fast. On their own they also make it
sloppy. Here is how I keep them in line:

- **A written plan before any code.** Each phase is planned and recorded in
  migration notes. Larger design documents also go through Elephant–Goldfish
  (EGM), a set of independent AI reviewers that check structure, technical
  accuracy and whether the plan is actually ready to implement.
- **Behaviour first, pixels later.** The first phase moves the back end to
  current Python and Django with the old look left intact. Because nothing
  changes for the user, any difference the tests catch is a migration bug.
- **Tests as the guard.** I write a test suite around the existing behaviour
  and a screenshot harness that compares pages and fails on any browser console
  error. The visual redesign only starts once both pass.
- **A rehearsal on real data.** Before the switch, a staging copy runs on the
  production server against a copy of the real database.
- **A cutover with a way back.** The old app stays in place as the rollback
  until the new one has proved itself.
- **A human in charge.** I own the architecture, the decisions and anything
  irreversible. The agents do the heavy lifting under rules I wrote.

## Bugs nobody noticed for years

A port that faithfully preserves behaviour also faithfully preserves the bugs.
So I measure and test the old app as well as the new one, and fix what turns
up. These were all older than the migration:

- **Registration input filtering had never run.** A jQuery plugin that was
  never shipped threw an error on every page load, from the day it was added.
- **Logged-out visitors got a 404 instead of the login page** on six views,
  because the login URL was never configured.
- **Two kinds of user ID were mixed up,** so pages that only worked while two
  database tables happened to stay in sync failed for most logged-in users.
- **Historic photos never appeared** on one page, because the template asked
  for a field name that didn't exist.
- **A deep link to an expanded section could never have worked:** the code
  used the wrong CSS class and the wrong element ID.
- **Four secrets were committed to the repository.**
- **Copying the old markup verbatim would have hidden every footer heading:**
  a CSS class that did nothing in Bootstrap 3 makes text white in
  Bootstrap 5.

## Recent work

### Geodetski portal (2026, volunteer)

Geodetic control points of the Croatian mountaineering network, on an
interactive map: [geopp.planinarski-portal.org](https://geopp.planinarski-portal.org)

- **Before:** Python 2.7, Django 1.11, Bootstrap 3 *and* 4 on the same site,
  Leaflet 0.7, assets loaded from third-party CDNs.
- **After:** Python 3.13, Django 5.2 LTS, PostGIS, Bootstrap 5.3, Leaflet 1.9,
  no CDNs, in Docker.
- **Cutover:** 2026-08-23, after a staging rehearsal on the production server.
  The old app is kept as the rollback.

### Planinarski portal (2026, volunteer)

A web GIS for Croatian mountain huts, control points and GPS tracks, with
search, trips, galleries and user accounts: [planinarski-portal.org](https://planinarski-portal.org)

- **Before:** Python 2.7, Django 1.5.
- **After:** Python 3.13, Django 5.2 LTS, PostGIS, Bootstrap 5, in Docker.
- **Cutover:** 2026-07-27.
- **After launch:** about 100 bot sign-ups a day were getting past reCAPTCHA.
  A hidden honeypot field didn't stop them, so registration now also asks a
  question any Croatian hiker can answer.

### The migration playbook

Everything these migrations taught me is written into one reusable Django
modernisation template:

- a phased runbook, from intake to the work after cutover
- a pre-flight checklist where every item is a real mistake from an earlier
  migration, together with the check that would have caught it
- a registry of more than 200 recorded capabilities and failure patterns,
  with a script that detects them in a new codebase
- ready-made deployment, security and operations scaffolding

It grew out of the Planinarski portal migration and has been used since on
two more apps: the Python 2 port of the Geodetski portal and the upgrade of a
newer Django app. The next app starts from everything the earlier ones
learned. The playbook itself stays private
because it describes production servers, but I'm happy to walk you through it.

## Is your app a fit?

Good candidates are web apps on old Python or Django, sites with a dated
frontend, and apps whose original authors have moved on. Email me what your
app runs on and how old it is: [info@arilus.hr](mailto:info@arilus.hr).
