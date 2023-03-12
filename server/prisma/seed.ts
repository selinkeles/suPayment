import { PrismaClient, Prisma } from '@prisma/client'

const prisma = new PrismaClient()

const userData: Prisma.UserCreateInput[] = [
  {
    name: 'Kamer Kaya',
    email: 'kamer.kaya@sabanciuniv.edu',
  },
  {
    name: 'Husnu Yenigun',
    email: 'husnuyenigun@sabanciuniv.edu',
  },
  {
    name: 'Erkay Savas',
    email: 'esavas@sabanciuniv.edu',
  },
  {
    name: 'Aydin Deniz Atalay',
    email: 'datalay@sabanciuniv.edu',
  },
  {
    name: 'Mustafa Yagiz Kilicarslan',
    email: 'ykilicarslan@sabanciuniv.edu',
  },
  {
    name: 'Osman Berke Yildirim',
    email: 'oberke@sabanciuniv.edu',
  },
  {
    name: 'Selin Keles',
    email: 'selinkeles@sabanciuniv.edu',
  },

]

async function main() {
  console.log(`Start seeding ...`)
  for (const u of userData) {
    const user = await prisma.user.create({
      data: u,
    })
    console.log(`Created user with id: ${user.id}`)
  }
  console.log(`Seeding finished.`)
}

main()
  .then(async () => {
    await prisma.$disconnect()
  })
  .catch(async (e) => {
    console.error(e)
    await prisma.$disconnect()
    process.exit(1)
  })
